
# 本文英文部分是@isaacs大佬写的make教程。
# make命令的详细手册：https://www.gnu.org/software/make/manual/make.html#toc-Overview-of-make
# make作为一个项目构建工具，不仅仅能够编译C\C++语言项目，任何只要某个文件有变化就需要重新
# 构建的项目，都可以使用make构建。
#
# 一篇博客：https://www.ruanyifeng.com/blog/2015/02/make.html。对make的基础使用
# 讲解的比较清楚。
#
# 在makefile里的命令当中要使用某个shell变量的值，需要在该变量前面加上两个$符号。
# %做模式匹配比较特殊，适合用来把所有某类型的文件变成另一种或者另一个位置的对应同名文件。
#
# 在编译C程序时，每一个.c文件的前置条件中都写上它引用的头文件，否则更新头文件之后，make
# 可能并不会重新编译项目。
#
# 变量可以在使用它的地方之后定义。
#


# Hello, and welcome to makefile basics.
#
# You will learn why `make` is so great, and why, despite its "weird" syntax,
# it is actually a highly expressive, efficient, and powerful way to build
# programs.
#
# Once you're done here, go to
# http://www.gnu.org/software/make/manual/make.html
# to learn SOOOO much more.

# To do stuff with make, you type `make` in a directory that has a file called
# "Makefile".  You can also type `make -f <makefile>` to use a different
# filename.
#
# A Makefile is a collection of rules.  Each rule is a recipe to do a specific
# thing, sort of like a grunt task or an npm package.json script.
#
# A rule looks like this:
#
# <target>: <prerequisites...>
# 	<commands>
#
#	前置条件通常是一组文件名，之间使用空格分割；只要有一个前置文件不存在，或者被更新过，
#   目标就需要重新构建
#	
#   目标通常也是文件名，目标还可以是一个操作的名字，即“伪目标”，如果make命令没有指定目标，
#   那么默认情况下执行第一个目标。
#
#	
#
# The "target" is required.  The prerequisites are optional, and the commands
# are also optional, but you have to have one or the other.
#
# Type "make" and see what happens:

tutorial:
	@# todo: have this actually run some kind of tutorial wizard?
	@echo "Please read the 'Makefile' file to go through this tutorial"

# By default, the first target is run if you don't specify one.  So, in this
# dir, typing "make" is the same as typing "make tutorial"
#
# By default, make prints out the command before it runs it, so you can see
# what it's doing.  This is a departure from the "success should be silent"
# UNIX dogma, but without that default, it'd be very difficult to see what
# build logs etc are actually doing.
#
# To suppress the output, we've added @ signs before each line, above.
#
#
# 每一行命令都在一个单独的shell中执行，这些shell之间无继承关系，所以在某一行中设置的变量无法传递到
# 下一行，可以理解为两行命令在不同的进程中执行吗？
# 解决方法是：
# 1. 把两行命令写在同一行里面，中间用；分割
# 2. 像下面的var-kept示例一样转译一下
# 3.在一个目标前面使用 .ONESHELL: 命令，这个方法没尝试成功
# Each line of the command list is run as a separate invocation of the shell.
# So, if you set a variable, it won't be available in the next line! To see
# this in action, try running `make var-lost`

var-lost:
	export foo=bar
	echo "foo=[$$foo]"

# Notice that we have to use a double-$ in the command line.  That is because
# each line of a makefile is parsed first using the makefile syntax, and THEN
# the result is passed to the shell.
# Let's try running both of the commands in the *same* shell invocation, by
# escaping the \n character.  Run `make var-kept` and note the difference.

var-kept:
	export foo=bar; \
	echo "foo=[$$foo]"


# 下面这个方法不大行的样子
.ONESHELL:
var-oneshell:
	export foo=bar;
	echo "foo=[$$foo]"


# Now let's try making something that depends on something else.  In this case,
# we're going to create a file called "result.txt" which depends on
# "source.txt".
# 有前置条件的规则，每一次执行：1.先检查前置条件；2，执行命令
result.txt: source.txt
	@echo "building result.txt from source.txt"
	cp source.txt result.txt


# When we type `make result.txt`, we get an error!
# $ make result.txt
# make: *** No rule to make target `source.txt', needed by `result.txt'.  Stop.
#
# The problem here is that we've told make to create result.txt from
# source.txt, but we haven't told it how to get source.txt, and the file is
# not in our tree right now.
#
# Un-comment the next ruleset to fix the problem.
#
#source.txt:
#	@echo "building source.txt"
#	echo "this is the source" > source.txt
#
# Run `make result.txt` and you'll see it first creates source.txt, and then
# copies it to result.txt.  Try running `make result.txt` again, and you'll see
# that nothing happens!  That's because the dependency, source.txt, hasn't
# changed, so there's no need to re-build result.txt.
#
# Run `touch source.txt`, or edit the file, and you'll see that
# `make result.txt` re-builds the file.
#
#
# Let's say that we were working on a project with 100 .c files, and each of
# those .c files we wanted to turn into a corresponding .o file, and then link
# all the .o files into a binary.  (This is effectively the same if you have
# 100 .styl files to turn into .css files, and then link together into a big
# single concatenated main.min.css file.)
#
# It would be SUPER TEDIOUS to create a rule for each one of those.  Luckily,
# make makes this easy for us.  We can create one generic rule that handles
# any files matching a specific pattern, and declare that we're going to
# transform it into the corresponding file of a different pattern.
#
# 这些自动变量都是跟通配符结合使用的，如果input和output已经确定，就没必要使用这些自动变量
# Within the ruleset, we can use some special syntax to refer to the input
# file and the output file.  Here are the special variables:
#
# $@  The file that is being made right now by this rule (aka the "target")
#     You can remember this because it's like the "$@" list in a
#     shell script.  @ is like a letter "a" for "arguments.
#     When you type "make foo", then "foo" is the argument.
#
# $<  The input file (that is, the first prerequisite in the list)
#     You can remember this becasue the < is like a file input
#     pipe in bash.  `head <foo.txt` is using the contents of
#     foo.txt as the input.  Also the < points INto the $
#
# $^  This is the list of ALL input files, not just the first one.
#     You can remember it because it's like $<, but turned up a notch.
#     If a file shows up more than once in the input list for some reason,
#     it's still only going to show one time in $^.
#
# $?  All the input files that are newer than the target
#     It's like a question. "Wait, why are you doing this?  What
#     files changed to make this necessary?"
#
# $$  A literal $ character inside of the rules section
#     More dollar signs equals more cash money equals dollar sign.
#
# $*  The "stem" part that matched in the rule definition's % bit
#     You can remember this because in make rules, % is like * on
#     the shell, so $* is telling you what matched the pattern.
#
# You can also use the special syntax $(@D) and $(@F) to refer to
# just the dir and file portions of $@, respectively.  $(<D) and
# $(<F) work the same way on the $< variable.  You can do the D/F
# trick on any variable that looks like a filename.
#
# There are a few other special variables, and we can define our own
# as well.  Most of the other special variables, you'll never use, so
# don't worry about them.
#
# So, our rule for result.txt could've been written like this
# instead:

result-using-var.txt: source.txt
	@echo "buildling result-using-var.txt using the $$< and $$@ vars"
	cp $< $@

# Let's say that we had 100 source files, that we want to convert
# into 100 result files.  Rather than list them out one by one in the
# makefile, we can use a bit of shell scripting to generate them, and
# save them in a variable.
#
# 看这一段，大佬对make的四种赋值方式也理解的不是很好？？？
# Note that make uses := for assignment instead of =
# I don't know why that is.  The sooner you accept that this isn't
# bash/sh, the better.
#
# Also, usually you'd use `$(wildcard src/*.txt)` instead, since
# probably the files would already exist in your project.  Since this
# is a tutorial, though we're going to generate them using make.
#
# This will execute the shell program to generate a list of files.
srcfiles := $(shell echo src/{00..99}.txt)   # 定义了一个变量

# How do we make a text file in the src dir?
# We define the filename using a "stem" with the % as a placeholder.
# What this means is "any file named src/*.txt", and it puts whatever
# matches the "%" bit into the $* variable.
# 在shell中，[]和[[]]都可以看作是一个命令
src/%.txt:
	@# First things first, create the dir if it doesn't exist.
	@# Prepend with @ because srsly who cares about dir creation
	@[ -d src ] || mkdir src
	@# then, we just echo some data into the file
	@# The $* expands to the "stem" bit matched by %
	@# So, we get a bunch of files with numeric names, containing their number
	echo $* > $@

# Try running `make src/00.txt` and `make src/01.txt` now.


# To not have to run make for each file, we define a "phony" target that
# depends on all of the srcfiles, and has no other rules.  It's good
# practice to define your phony rules in a .PHONY declaration in the file.
# (See the .PHONY entry at the very bottom of this file.)
#
# Running `make source` will make ALL of the files in the src/ dir.  Before
# it can make any of them, it'll first make the src/ dir itself.  Then
# it'll copy the "stem" value (that is, the number in the filename matched
# by the %) into the file, like the rule says above.
#
# Try typing "make source" to make all this happen.
# 这个地方要正确理解所有的文件是怎么产生的，“make source”为了制作目标source，会检查每一个前置文件
# 是否存在，是否更新。比如检查到src/00.txt不存在，那么会找如何生成它的规则，找到
#source: $(srcfiles)


# So, to make a dest file, let's copy a source file into its destination.
# Also, it has to create the destination folder first.
#
# The destination of any dest/*.txt file is the src/*.txt file with
# the matching stem.  You could just as easily say that %.css depends
# on %.styl
dest/%.txt: src/%.txt
	@[ -d dest ] || mkdir dest
	cp $< $@

# So, this is great and all, but we don't want to type `make dest/#.txt`
# 100 times!
#
# Let's create a "phony" target that depends on all the destination files.
# We can use the built-in pattern substitution "patsubst" so we don't have
# to re-build the list.  This patsubst function uses the same "stem"
# concept explained above.

# destfiles是一个在定义时扩展的变量
destfiles := $(patsubst src/%.txt,dest/%.txt,$(srcfiles))
# destination: $(destfiles)   # makefile文件中定义的变量应该是可以在后续规则的前置条件和命令行中使用的

# Since "destination" isn't an actual filename, we define that as a .PHONY
# as well (see below).  This way, Make won't bother itself checking to see
# if the file named "destination" exists if we have something that depends
# on it later.
#
# Let's say that all of these dest files should be gathered up into a
# proper compiled program.  Since this is a tutorial, we'll use the
# venerable feline compiler called "cat", which is included in every
# posix system because cats are wonderful and a core part of UNIX.

# 之前对makefile的理解被垃圾误导了，make时并不是从文件自上而下的查找各个文件，这些规则写的顺序不那么重要
kitty: $(destfiles)
	@# Remember, $< is the input file, but $^ is ALL the input files.
	@# Cat them into the kitty.
	cat $^ > kitty

# Note what's happening here:
#
# kitty -> (all of the dest files)
# Then, each destfile depends on a corresponding srcfile
#
# If you `make kitty` again, it'll say "kitty is up to date"
#
# NOW TIME FOR MAGIC!
#
# Let's update just ONE of the source files, and see what happens
#
# Run this:  touch src/25.txt; make kitty
#
# 这就是make的强大之处，上面这个过程类似于编译一个C语言项目。改了其中一个源文件时，只有那个
# 源文件会被重新编译，然后对所有文件做一个链接。
#
# Note that it is smart enough to re-build JUST the single destfile that
# corresponds to the 25.txt file, and then concats them all to kitty.  It
# *doesn't* re-generate EVERY source file, and then EVERY dest file,
# every time


# It's good practice to have a `test` target, because people will come to
# your project, and if there's a Makefile, then they'll expect `make test`
# to do something.
#
# We can't test the kitty unless it exists, so we have to depend on that.
test: kitty
	@echo "miao" && echo "tests all pass!"

# Last but not least, `make clean` should always remove all of the stuff
# that your makefile created, so that we can remove bad stuff if anything
# gets corrupted or otherwise screwed up.
clean:
	rm -rf *.txt src dest kitty

# What happens if there's an error!?  Let's say you're building stuff, and
# one of the commands fails.  Make will abort and refuse to proceed if any
# of the commands exits with a non-zero error code.
# To demonstrate this, we'll use the `false` program, which just exits with
# a code of 1 and does nothing else.
badkitty:
	$(MAKE) kitty # The special var $(MAKE) means "the make currently in use"
	false # <-- this will fail
	echo "should not get here"


# 在文件的最后集中定义伪目标
.PHONY: source destination clean test badkitty
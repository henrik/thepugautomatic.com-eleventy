---
wordpress_id: 167
title: Tasks bundle for TextMate
categories:
- OS X
- TextMate
date: 2007-08-11 20:19
layout: post
comments: true
---
I came across <a href="http://hogbaysoftware.com/projects/taskpaper">TaskPaper</a> the other day &ndash; a simplistic to-do list app currently in development by Jesse Grosjean, who made the equally simplistic text editor <a href="http://hogbaysoftware.com/projects/writeroom">WriteRoom</a>.

In TaskPaper, your to-do list is in a simple text format like

``` text
Project 1:
- task 1
- task 2 @done
Project 2:
- task 3
```
and presented with visual and functional improvements.

I'm a big fan of piggybacking on formats like this: taking something people are already doing, like this list markup, and adding value. The to-do lists I keep in plain text files are pretty much formatted this way, except for the tags (like <code>@done</code>).

However, I edit my text files in <a href="http://macromates.com/">TextMate</a>. Using something else for to-do list text files complicates things. So I made a TextMate bundle for it:

<p class="center"><img src="http://henrik.nyh.se/uploads/textmate_tasks-bundle.png" alt="[Screenshot]" /></p>

<!--more-->

Download it here, unarchive, then double-click to install: <a href="http://henrik.nyh.se/uploads/Tasks.tmbundle.zip">Tasks.tmbundle.zip</a>

It's named "Tasks" rather than "To-do" since a "TODO" bundle ships with TextMate (it finds "TODO" and "FIXME" comments in code).

This is a pretty simple bundle. I don't need any special handling of priorities or due-dates. Feel free to modify it to fit your preferred markup and way of working.

<h4>File format</h4>

The Tasks grammar and commands by default apply to files with the <code>.todo</code>, <code>.todolist</code> and <code>.tasks</code> extensions.

Headers end with a colon (":"). Headers are listed in the <a href="http://macromates.com/textmate/manual/navigation_overview#function_pop-up">symbol list</a>. Somewhat unfortunately, checkmarks are used in the symbol list to denote the current item. That checkmark obviously does not reflect the to-do status of anything.

Pending (uncompleted) tasks start with a hyphen ("-"). Completed tasks start with a checkmark ("✓"). The easiest way to get the checkmarks is to first add a pending task and then toggle it using the command described below.

Headers and tasks can be indented for grouping/hierarchy, as seen in the screenshot above.

<h4>Commands</h4>

<h5>New Task</h5>

Press <code>&#x2305;</code> to insert a new task.

The command has some smarts: if the caret is on the same line as a task but before the hyphen/checkmark, the new task is inserted above; if the caret is after a task, the task is inserted below. If the caret is inside the task, the line breaks, splitting the task in two. If the caret is on a blank line, a new task is inserted there without adding line breaks.

<h5>Toggle Completed</h5>

Press <code>&#x2325;&#x2305;</code> to toggle completion for a task or set of tasks.

If no text is selected, the task on the current line is toggled: if it's pending, it's marked as completed and vice versa.

If text is selected, every task in the selection is toggled in batch: if any of the tasks are pending, all are marked as completed; if all are completed, they're marked as pending.

<h5>Other commands</h5>

In addition to these specific commands, you can obviously use general TextMate features like undo, Duplicate Line (<code>&#x2303;&#x21E7;D</code>), Current Date (<code>isoD&#x21E5;</code>), move lines up (<code>&#x2303;&#x2318;&#x2191;</code>) and down (<code>&#x2303;&#x2318;&#x2193;</code>)…

There. That's one less thing to do.

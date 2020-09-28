---
title: Scheduled Roborock cleaning with a prompt using iOS Shortcuts
tags:
  - Automation
---

You can configure a [Roborock](http://roborock.com/) robot vacuum to run automatically on a schedule.

I don't want that – I want to move some things out of the way first, and check that the cats haven't left us any surprises.

But I like the idea of a *semi-automatic* schedule, where the vacuum prompts me at a given time, and then waits for me to give the go-ahead.

I realised this can be achieved with [iOS Shortcuts](https://support.apple.com/en-gb/guide/shortcuts).

It's not quite a one-tap prompt – your phone will show a notification saying your automation is running, and then one saying "Tap to respond".

![Screenshot](/images/content/2020-09-28/respond.png)

When you tap it, it shows the prompt. (This is good, really, since it lets you wrap up whatever you were doing instead of forcing you to answer the prompt immediately.)

![Screenshot](/images/content/2020-09-28/prompt.png)

And when you've tapped "OK", the vacuum's Xiaomi Home app will tell you it ran, which you get to discard.

![Screenshot](/images/content/2020-09-28/ran.png)

## Adding a Siri shortcut

First we make it possible for Siri (and thus Shortcuts) to start the vacuum at all.

In the vacuum's "Xiaomi Home" app, go to the top-level "Automation" tab.

Press "+", select "Complete manually", select your vacuum and the "Start cleaning" action. Save.

Now tap "Add to Siri" until you get to the system's "Add to Siri" (!) screen.

The shortcut name you specify here doesn't matter for the automation we will be adding, but if you plan on triggering it from Siri as well, pick something suitable. Then press the "Add to Siri" button.

You should now be able to trigger your shortcut by saying "Hey Siri, start cleaning" or whatever phrase you picked.

## Automate the shortcut

Now open the "Shortcuts" app. You may need to [install it](https://apps.apple.com/app/shortcuts/id915249334) if you don't already have it.

Under the top-level "Automation" tab, click "+".

Select "Create Personal Automation".

Pick "Time of Day", then specify whatever suits you – daily, weekly (some given days each week), or monthly (some given days each month).

Now "Add Action". Use the search functionality to find "Show Alert". Tap it to add it.

Modify the text (tap it, then use the keyboard) to whatever prompt you like.

Now tap "+" to add another step. When the automation runs, it will only proceed to this next step if you selected "OK" at the prompt.

Now search for "Xiaomi" and tap the action we added before, e.g. "Run scene 'Start cleaning'".

Press "Next". Uncheck "Ask Before Running" unless you want prompts while you prompt, dawg.

Press "Done" – and that's it!

If you're impatient to see that it works, edit it to run very soon, then edit it back to regular scheduling.

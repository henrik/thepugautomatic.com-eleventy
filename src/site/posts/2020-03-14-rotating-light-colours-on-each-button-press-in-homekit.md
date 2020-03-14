---
title: Rotating light colours on each button press in HomeKit
tags:
  - HomeKit
  - Home automation
---

We've got a pair of lights in our front room set up to rotate colours on each press of a button.


<!-- https://embedresponsively.com/ -->
<style>.embed-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; margin: 30px 0; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'><iframe src='https://www.youtube.com/embed/wSfAzTavfno' frameborder='0' allowfullscreen></iframe></div>

So on the first press, the lights turn on and become red and green. On the second press, they change to pink and orange. On the third press, they turn off again. You don't need to repeat presses quickly – if they're currently red and green, pressing the button again even an hour later will change them to pink and orange.

These are Hue lights, with the Hue dimmer switch as a remote. (It lives in a pretty box when not in use.)

I used [the Eve app](https://apps.apple.com/app/eve-for-homekit/id917695792) to set this up, since it lets you make more advanced automations than Apple's Home app or the Hue app.

## How to set it up

This is not a step-by-step tutorial; I'll assume you can fill in the blanks.

In the Eve app, find the dimmer switch via the "Rooms" tab, and tap (in the app) on the button you want.

Now we'll add a "rule" for each colour change. I've got rules for:

* Off to red/green
* Red/green to pink/orange
* Pink/orange to off

When you add the rule and get to the "Conditions" step, choose "Add Value Condition".

When you're setting up the "Off to …" rule, the condition will simply be that one of the lights (take your pick) is off.

![Screenshot of rules](/images/content/2020-03-14-eve/cond_off.png)

When you're setting up the "colour A to colour B" or "colour B to off" rules, the condition will be the current colour of one of the lights (again, take your pick) *and* that the light is powered on.

![Screenshot of rules](/images/content/2020-03-14-eve/cond_colours.png)

It's important that the condition checks that the light is powered on. If you don't, you're likely to see strange behaviour, because lights still have a colour when off.

When you add a new condition based on the current colour (hue), it seems to be pre-populated with the current colour. This means that to set up the "red/green to pink/orange" rule, you should first change the light colours to red/green, then add a rule.

Once you've set up the conditions, you get to select the scene that should be set. This is just a scene that either turns both lights on with the desired colours, or that turns both of them off. You could create this scene in the Eve app or in the Home app.

Name the rule anything you like.

That's it! Let me know about any alternative ways to set this up in the comments or [on Twitter](https://twitter.com/henrik).

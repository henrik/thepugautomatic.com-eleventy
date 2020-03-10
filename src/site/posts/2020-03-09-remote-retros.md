---
title: How we do remote retros
tags:
  - Methodology
  - Remote work
---

[My team](https://dev.auctionet.com/) has tried various ways to do remote retros and finally found something that works really well for us.

## Context

We're a small team (around 6 devs). Everyone works from home, though occasionally two people visit the office at the same time.

## Ingredients

* A shared video meeting with screen-sharing capabilities. We use [Zoom](https://zoom.us/).
* A shared [Trello](https://trello.com/) board with these columns:
  * Ideas inbox
  * To discuss
  * Being discussed
  * Done discussing
  * Actions
  * Feedback
* A facilitator/note-taker
  * sharing their screen, showing the Trello board via Zoom
  * with a timer (e.g. a smart phone) to hand.

## Phase 1: Follow up on the previous retro

We go through the "Actions" column in Trello to see that we've done what we decided.

We go through the "Feedback" column, with feedback we collected after the last retro – perhaps we want to change something this time.

The facilitator leads this process, showing Trello on their shared screen.

## Phase 2: Gather topics

We can put ideas in the "Ideas inbox" column at any time, not just during the retro.

But we also take about 5 minutes for everyone to think back and add any additional cards. Everyone does this from their own computer.

## Phase 3: Vote with your face

We quickly go through the "Ideas inbox", briefly explaining any cards that aren't obvious.

Then we vote by "putting our faces on the cards" – hover a card and press Space to add yourself as a member of that card, showing your user picture on it. We allow voting on up to 3 cards. You can't vote multiple times on the same card – that's mostly a technical limitation of using "faces on cards".

Usually we'll put two "Ideas" columns side by side, just to fit all the cards on the facilitator's screen without scrolling.

We also have "Blank vote 1", "Blank vote 2", "Blank vote 3" cards so people can vote on those if they don't have enough "real" cards they want to vote on. That makes it easier for the facilitator to see if everyone's done voting.

We move the cards with votes to the "To discuss" column, sorted most-votes-first – though we may sometimes mix it up a bit, e.g. putting short and cheerful topics in between "heavier" topics.

## Phase 4: Discuss

### Running notes

When we start discussing a topic, the facilitator opens that Trello card and starts writing running notes in a comment. This is on a shared screen, so everyone sees it as it's being written. It's not verbatim – just key points, which is easier to keep up with than one might expect:

> - Alice: I think we should arrange a retreat. Maybe in summer?

We can then go through these notes when wrapping up the topic to figure out actions. If anyone missed the retro, or want to refresh their memory, they can read the notes.

But the running notes also help us keep track of whose turn it is. If Bob raises his hand, the facilitator makes a note, and then goes back to noting down key points from what Alice is saying.

> - Alice: I think we should arrange a retreat. Maybe in summer? Southern Sweden?
> - Bob:

Now Bob knows he's next up and can lower his hand. If Carol also wants to say something, the facilitator puts her name after Bob's in the same way.

If Carol wants to reply directly to the current speaker rather than raise a separate point, she can raise her index finger, and she gets to cut in line:

> - Alice: I think we should arrange a retreat. Maybe in summer? Southern Sweden?
> - Carol (reply):
> - Bob:

### Roman voting

The discussion phase borrows "Roman voting" from [Lean Coffee](http://agilecoffee.com/leancoffee/).

The facilitator sets a 5 minute timer. On their phone, not visible to everyone (though that could be interesting to try). When the timer goes off, the facilitator makes a note about voting after the current speaker.

> - Carol: The west coast is nice.
> - vote!

Then there's a round of "Roman voting" – thumbs up to continue, thumbs down to change topics, or thumb to the side if you're not sure.

If there's a majority of thumbs up, we continue for another 5 minutes before voting again. Otherwise, we summarise actions and move on to the next topic. (Though we still haven't quite settled on whether a thumb to the side is a neutral vote or a negative vote. Should continuing require a thumbs-up majority, or just the absence of a thumbs-down majority? As [co-worker Tomas](https://github.com/tskogberg) quipped, it's just a rule of thumb…)

The beauty of Roman voting is that it's up to the team to decide whether they want to go deep on a small number of topics or to cover more ground. It also avoids people zoning out and discussions going in circles.

It may sound disruptive, but it's really quick.

### Breaks

We try to take roughly a 5 minute break every 30 minutes or so.

The facilitator suggests one at a suitable time – by putting it into the running notes:

> - Alice: Furthermore, I consider that Carthage must be destroyed.
> - Bob:
> - break!

## Phase 5: Evaluate

We usually set aside about 2 hours for a retro. At the end of that period, we wrap up the discussion and spend 5 minutes evaluating the retro itself.

This part is key – a lot of the little things we like about this retro format started out as suggestions during evaluation. We note these down in the "Feedback" column so we can look at them at the beginning of the next retro.

After everyone's left, the facilitator looks through the cards and puts the actions in the "Actions" column, so we can more easily follow up on them next time.

## Feedback welcome

I'd love to hear how other distributed teams do it. Please let me know in the comments or [on Twitter](https://twitter.com/henrik)!

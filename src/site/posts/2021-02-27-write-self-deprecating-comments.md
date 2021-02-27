---
title: Write self-deprecating comments
tags:
  - Code style
---

Comments easily get out of sync with their code, but there are tricks to lessen the impact.

Instead of

``` ruby
PaymentAPI.call(
  mode: "X",  # Disable 3D Secure verification.
  timeout: 12,  # The smallest value that avoids errors.
)
```

, write

``` ruby
PaymentAPI.call(
  mode: "X",  # "X": Disable 3D Secure verification.
  timeout: 12,  # 12 secs is the smallest value that avoids errors.
)
```

This double-entry bookkeeping means you can easily tell when the code and comment drift apart:

``` ruby
PaymentAPI.call(
  mode: "Y",  # "X": Disable 3D Secure verification.
  timeout: 15,  # 12 secs is the smallest value that avoids errors.
)
```

Whether the discrepancy is caught immediately by the author, or in review, or by another developer far down the line, it will be explicitly clear that the comment was not intended for the current value.

This technique is a great fit for short-and-cryptic values like these. Longer values would be annoying to repeat, but also tend to be more self-documenting.

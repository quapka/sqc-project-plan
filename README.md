# Description

This text describes the project plan for the [SquareCrypto grant](https://squarecrypto.org/#grants) regarding the transition from Stratum v1 protocol to v2.

# The project plan

TBD

# Questions and topics

In no particular order - simply stuff that has crossed my mind and I'd like to articulate it somewhere.

## General

1. How to do testing in Rust?
1. How to achieve testing as close to the real use as possible (pools, v1 only, v1/v2, v2 only devices)?


## Rust-related

- Explicit (taken from Python experience: _explicit over implicit_) typing?
- Custom types/structs for any part of the v1/v2 protocol to avoid handling values that don't have meaning?
- Use functional style of programming? Seems quite appropriate due to the goal of proxy v1-v2.
- _Session types_ - methods returning different states so that invalid (logically) method can't be called.

## Attacks and weaknesses
- What is the size of the packets? Can something be inffered from the observation of packet size and frequency (even if the packets are encrypted)? Idea from [Ruben Recabarren - Hardening Stratum, the Bitcoin Pool Mining Protocol](https://www.youtube.com/watch?v=sFdeeddVEpI).

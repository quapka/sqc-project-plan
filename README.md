# Description

This text describes the project plan for the [SquareCrypto grant](https://squarecrypto.org/#grants) regarding the transition from Stratum v1 protocol to v2. The plan outlines what will be implemented and with what implementation goals in mind. What follows now is the project plan.

# The project plan (Work In Progress)

## Related documents

The [Stratum v2 protocol specifications](https://docs.google.com/document/d/1FadCWj-57dvhxsnFM_7X806qyvhR0u3i85607bGHxvg/edit) is where the definition of the protocol is. Another general points regarding the protocol, its comparison to v1 version and useful definitions are at [Stratum v2 (protocol) homepage](https://braiins.com/stratum-v2).

The following text goes into varying level of detail. The goal is to outline with what intentions will the execution of the plan be carried out. Due to the scope and severity of this project the different sections might be subject to change(s) in the future.

The overall idea is to create a well test and stable code rather than come up with a quickly stitched together spaghetti code that might get prematurely deployed by mining enthusiasts and cause issues and consequently discourage the upgrade from v1 to v2 in general. Therefore, rather a conservative approach is planned to be taken.

## What has already been done

Studying Rust, bitcoin and Stratum v1/v2 protocol specifications. The incomplete list is tracked on dedicated [trello board](https://trello.com/b/4UIMBDhJ/sqc-project-plan).

## Improving specifications

## What to implement

Stratum v2 protocol consists of multiple subprotocols.

### Mining Protocol

This sub-protocol is the starting point for the project and as such will be worked on from the start. First standard channels will be implemented and then group channels (as they seem like a logical next step). Extended channels will be the last to be implemented. This scenario makes sense, but e.g. the implementaiton of standard channels might show the need to implement parts of the code for the other channels as well (or at least prepare the ground for them).


### Template Distribution Protocol

### Job Negotiation Protocol

While not a necessity in Stratum v2 Job Negotiation sub-protocol supports decentralization and as such is a valuable puzzle piece in the protocol framework.

### Job Distribution Protocol
TODO:
Job Distribution being a complementary part makes it sensible to work on those together.

## Key aspects implementation-wise

The project concerns Stratum V2 sub-protocols that are critical pieces of the future of mining pools existence. Therefore a good care and practices are needed to help deliver a good and reliable piece of software.

[Git](https://git-scm.com/download/win) will be used for version control of part of the project. A specific branch and commit plan will be probably discussed (e.g. `main`, `dev` and `feat` branches). The goal is to use simple yet effective way of collaboration to encourage collaborations while maintaining transparency, good code organisation and stability.

### Code refactoring

The vast majority of the code is expected to be implemented in [Rust](https://www.rust-lang.org/). This programming language is rather new and while stable it is still developing. Therefore the ability to refactor the code is anticipated --- this should be reflected e.g. by having the test suites _rich_ and _flexible_ enough to encourage refactoring. Further refactoring is motivated also by the goal of implementing a new protocol where the actual usage can lead to furter alterations and improvements of the specs.

Significant code refactorings are more than expected as Bitcoin (implementation-wise) and Rust are new areas for the grantee. However, Rust and its features have already been studied a lot by the grantee.

### Code testing

The code should have _sufficient_ (more than 90\%) test coverage. Blindly chasing 100\% can be counter-productive, but is, of course, welcomed.
The tests should range from simple unit tests (at the level of an individual functions) and functional tests to as close to the real-case use as possible (running on actual mining devices and pool servers). Real hardware tests can come at costs and support from existing mining pools might be asked for.

Continuous Integration should be used and should _not depend_ on the platform used. E.g. have multiple mirrors and CI setups can be used ([Github](https://www.github.com), [Gitlab](https://www.gitlab.com)).

Tests on multiple levels and scenarios will be implemented. The specifications mentions various setups, multiple mining devices, backends, proxies. As many as possible should be tested out of those if they are not covered by another setup (the protocols usages are described in the beginning of the Startum v2 specifications). To help refactoring _implementation details independent_ tests will be attempted (of course, each test does depend in at least some way on the implementation).

While it's not unheard of that Rust's pedantic compiler provide quite a lot of assurance the project seems like a great candidate for using fuzzing techniques to test it. On a high level, e.g. the translation between v1 and v2 alone is a great candidate for fuzzing (consider migration from JSON in v1 to binary in v2). Also the protocol itself needs to be robust and handle any incoming bytestream accordingly (interpret valid messages and give and error in case of invalid ones in general).

### Performance profiliing

Related to code testing is profiling and performance benchmarking of the implementation. The motivation is to actually see that Stratum V2 provides improved performance over the previous version. The details of the  granularity and focus of performance profiling are to be discussed. Overall performance gain might be the most important, but the knowledge of which Stratum V2 features do allow it is beneficial as well. Relation to code testing is due to the necessity to profile the code on a real hardware if possible. One concern with Stratum v2 is how big encryption overhead will be --- this is another area, where performance profiling can give a meaningful answer.

### Code revisions

Since _all_ the code that will be produced as part of this project will be open-sourced everyone will be invited and welcomed to review both the code and the specifications.

Apart from the usual code reviews --- that are more than welcomed as it is important open source project. It would be beneficial to have a dedicated review regarding:
- the security of the implemenation (more in the Security section)
- Rust implementation (especially due to its evolving nature, new editions and features can emerge)
- API and protocol implementation (the real use cases can shown issues regarding the API)

The specific details (where and how to report) regarding collaboration might emerge eventually (e.g. less formal issues might be accepted at the beginning, but this can change if the number of code reviews will increase). The exampler categories (imagine issue labels) are: `security` (e.g. exploitable bugs with varying level of severity), `protocol` (e.g. bugs in the specification), `rust` (e.g. misuse/improper of Rust language features. Understandably, there will be overlap, but the goal is to make collaboration transparent, simple and well articulated.

An appropriate way for necessary communication about all the topics will be chosen. The public issue trackers are a good place for general discussions, but a dedicated messaging app might be used for more efficient communication among the daily developers working on Stratum v2 protocol.

### Rust-related

The separation into modules and libraries can evolve in time. However, some general goals that can already be laid out:

- explicit (taken from Python experience: _explicit over implicit_) typing to avoid passing _syntactically_ correct, but _semantically_ incorrect data around. Therefore using custom types/structs for any part of the v1/v2 protocol to avoid handling values without meaning,
- considering using functional style of programming. This seems appropriate e.g. for the translation proxy between the v1 and v2 versions. Proclaimed Rust's zero-cost-abstraction should allow no increase in performance costs (this can be tested),
- using _session types_ --- methods returning different _state_  `structs` so that logically invalid function calls and data flows won't occur,
- usage of 3rd party libraries and code should be limited to the absolute necessity and to the cases, where it makes sense (e.g. the Noise Protocol framework). However, blind usage is discouraged and active approach towards those libraries will be taken (e.g. code review, upstream fixes, etc.).

### Security

Among other goals Stratum v2 aims to significantly improve the security and privacy of pool mining. Those goals should be actively tested and discussed.

Author's master's degree is in Cybersecurity therefore it's natural that I'd like to focus on not just implementing Stratum v2 specifications, but focus on the security as well. As security is always a broad topic the following list is rather illustrative:

- try to actually put the security in tests. This can include recording a the protocol messages and testing the expected entropy of the encrypted data stream 
- testing the randomness of the random sources in the application (whether to do this in the runtime as well is up to a discussion)
- use Rust features like ownership/borrowing and slicing (pointer views) to avoid unnecessary data copying (e.g. private/secret keys can reside only in one place in the memory), so the benefits are not only performance-wise (less data copying)
- [Noise protocol](https://noiseprotocol.org) is suggested to be used. This protocol or rather protocol framework is rather new, so a care and analysis will be taken in order to attempt to prevent misusing/misimplementing it.
- general code-reviews with security in mind will be encouraged


## Attacks and weaknesses


- What is the size of the packets? Can something be inffered from the observation of packet size and frequency (even if the packets are encrypted)? Idea from [Ruben Recabarren - Hardening Stratum, the Bitcoin Pool Mining Protocol](https://www.youtube.com/watch?v=sFdeeddVEpI).


## Stratum v2 discussion, comments and review

## Questions and topics

In no particular order - simply stuff that has crossed my mind and I'd like to articulate it somewhere.

## General

1. How to do testing in Rust?
1. How to achieve testing as close to the real use as possible (pools, v1 only, v1/v2, v2 only devices)?


## Assisting in the deployment of Stratum v2

Talks, tutorials, screencasts, blogs reflecting the questions and topics arising from Bitcoin community.

### Improvements as described at Stratum v2 homepage
[Bandwidth consumption](https://braiins.com/stratum-v2#bandwidth)
Server CPU load
Job distribution latency
Binary vs. non-binary
Man-in-the-middle attack prevention
Empty block mining elimination
Job selection
Header-only mining
Multiplexing
Implicit work subscription
Native version rolling
Zero-time backend switching
Different type of jobs on the same connection

Translations v1-v2-v1

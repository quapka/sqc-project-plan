# The project plan (Work In Progress)

This text describes the project plan for the [SquareCrypto grant](https://squarecrypto.org/#grants) regarding the transition from Stratum V1 protocol to V2. The plan outlines what will be implemented and with what implementation goals in mind.

The overall idea is to create a well tested and stable code rather than come up with a quickly stitched together spaghetti code that might get prematurely deployed by mining enthusiasts and cause issues and consequently discourage the upgrade from V1 to V2 in general. Therefore, rather a conservative approach is envisioned. This text is authored by Jan Kvapil.

## Related documents

The [Stratum V2 protocol specifications](https://docs.google.com/document/d/1FadCWj-57dvhxsnFM_7X806qyvhR0u3i85607bGHxvg/edit) is where the definition of the protocol is. Another general points regarding the protocol, its comparison to V1 version and useful definitions are at [Stratum V2  homepage](https://braiins.com/stratum-v2). Related sources are Stratum V1 [homepage](https://braiins.com/stratum-v1),  [docs](https://braiins.com/stratum-v1/docs) and [Github repository](https://github.com/braiins/braiins/tree/bos-devel/open/protocols/stratum).


## Overarching project goals

Since the work on the open-source implementation of Stratum V2 might be started by two SquareCrypto grantees, those potential grantees decided to come up with overarching goals for both grants. These goals are co-authored with Filippo Merli.

### One year goal (WIP)


Write a final [Bitcoin Improvement Proposal](https://github.com/bitcoin/bips/blob/master/bip-0001.mediawiki#What_is_a_BIP) that defines the Stratum V2 protocol. The BIP will be supported by:

1. A well tested Rust implementation of Stratum V2 (not necessarily the "final" implementation).
1. Benchmarks supporting the claims of Stratum V2.
1. Security reviews and tests of the implementation.
1. Actual implementations of possible real use cases.
1. Tutorials and articles.
1. Having a PR with at least concept ACK on Bitcoin Core. The PR implements the Stratum V2 protocol (Template Provider) in Bitcoin Core using the above (point one) Rust library.

## What has already been done

Studying Rust, Bitcoin and Stratum V1/V2 protocol specifications. The incomplete list is tracked on dedicated [Trello board](https://trello.com/b/4UIMBDhJ/sqc-project-plan). Discussing Stratum V2 and the goals above with Jan Čapek and Matt Corallo.

The topics discussed so far have included the usage of error strings vs. error codes, using Protocol Buffers vs. custom message structure, allowing different encryption schemes on the pool side (ChaCha, AES-GCM), adding new mining message due to troubles with V1--V2 translation proxy.

## Improving Stratum V2 specifications

The specifications are quite detailed already, however, they are not finished. The finalization of the Stratum V2 specifications will be done in parallel with the reference implementation (during the grant-time). In order to bring more eyes to have a look on Stratum V2 specifications I will start by creating a BIP proposal (migrating the current [Google Document](https://docs.google.com/document/d/1FadCWj-57dvhxsnFM_7X806qyvhR0u3i85607bGHxvg/edit) into the MediaWiki format). This step will probably be done with the assistance of the original authors (Pavel Moravec, Jan Čapek and Matt Corallo, etc.) as they are in a more suitable position to make the initial proposal.

The scope of the BIP might be up to a decision. The Template Distribution Protocol will be done in Bitcoin Core so maybe a dedicated BIP for this sub-protocol might be used. Either way this BIP will probably replace [BIP-0022](https://github.com/bitcoin/bips/blob/master/bip-0022.mediawiki) and [BIP-0023](https://github.com/bitcoin/bips/blob/master/bip-0023.mediawiki) that specify `getblocktemplate`.

In order **not** to have the reference implementation deviate from the specifications it is worth investigating the idea of auto-generating parts (or full, if possible) of the specifications from the reference implementation. Auto generated documentation from Rust code is a standard practice.

## What will be implemented

Stratum V2 protocol consists of multiple sub-protocols.

### Mining Protocol

This sub-protocol is the starting point for the project and as such will be worked on from the start. First standard channels will be implemented and then group channels (as they seem like a logical next step). Extended channels will be the last to be implemented. This scenario makes sense, but e.g. the implementation of standard channels might show the need to implement parts of the code for the other channels as well (or at least prepare the ground for them). The translation proxy between V1--V2 will be implemented here as well.


### Template Distribution Protocol

This sub-protocol implements the successor to the `getblocktemplate` functionality that is responsible for giving a next template for a future block. This sub-protocol is probably the only part that needs to touch Bitcoin Core and most probably won't be implemented in Rust, but in C++.

### Job Negotiation Protocol and Job Distribution Protocol

While not a necessity in Stratum V2 Job Negotiation sub-protocol supports decentralization and as such is a valuable puzzle piece in the protocol framework. If the work on the other parts of this plan will progress better than expected then work on Job Negotiation Protocol and Job Distribution Protocol will start as well.

### Testing infrastructure

Apart from unit-tests that are discussed later I propose to create more elaborate testing eco-system that would include the various mining components --- mining pools, mining proxies and mining devices. Those will probably be implemented as a separate Rust (library) crate and allow to test and monitor Stratum V2 implementation in various setups. Example setup can be mining pool running Stratum V1, mining proxy with translation V1--V2 and several mining devices. Different tests and simulations will require different features (e.g. some might omit the TCP/IP layer since all the test devices will be implemented in software and ran on a single device, so that the transportation layer won't be needed). The various setups provide trade-offs between speed of testing/simulations and closeness to the real-world mining scenario.

## Key aspects implementation-wise

The project concerns the Stratum V2 sub-protocols that can be critical pieces of the future of mining pools. Therefore a good care and practices are needed to help to deliver a stable and reliable piece of software.

### Code refactoring

The vast majority of the code is expected to be implemented in [Rust](https://www.rust-lang.org/). This programming language is rather new and while stable it is still developing. Therefore the ability to refactor the code is anticipated --- this should be reflected e.g. by having the test suites _rich_ and _flexible_ enough to encourage refactoring. Further refactoring is motivated also by the goal of implementing a new protocol where the actual usage can lead to future alterations and improvements of the specs.

### Code testing

The code should have _sufficient_ (more than 90+\%) test coverage. The tests should range from simple unit tests (at the level of an individual functions) and functional tests to as close to the real-case use as possible (running on actual mining devices and pool servers).

Tests on multiple levels and scenarios will be implemented. The specifications mention various setups, multiple mining devices, backends, proxies. As many as possible should be tested out of those if they are not covered by another setup. To help refactoring _implementation details independent_ tests will be attempted.

The project seems like a great candidate for using fuzzing techniques to test it. On a high level, e.g. the translation between V1 and V2 alone is a great candidate for fuzzing (consider migration from JSON in V1 to binary in V2). Also the protocol itself needs to be robust and handle any incoming bytestream accordingly (interpret valid messages and give and error in case of invalid ones in general). The fuzzing should include exchanges of multiple messages to simulate full _conversation_ amongst the pools, proxies and devices and not just single request-response type.

### Performance profiling

Related to code testing is profiling and performance benchmarking of the implementation. The motivation is to see that Stratum V2 provides improved performance over the previous version. The details of the  granularity and focus of performance profiling are to be discussed. Overall performance gain might be the most important, but the knowledge of which Stratum V2 features do allow it is beneficial as well. Relation to code testing is due to the necessity to profile the code on a real hardware if possible. One concern with Stratum V2 is how big will be the encryption overhead.

### Code revisions

Since _all_ the code that will be produced as part of this project will be open-sourced everyone will be invited and welcomed to review both the code and the specifications. Apart from the usual code reviews it would be beneficial to have a dedicated reviews regarding (details in the Appendix):

- the security of the implementation
- Rust implementation (especially due to its evolving nature: new editions and features can emerge)
- API and protocols implementation

### Rust-related

The separation into crates, modules and libraries can evolve in time. However, some general goals that can already be laid out:

- explicit (taken from Python experience: _explicit over implicit_) typing to avoid passing _syntactically_ correct, but _semantically_ incorrect data around. Therefore using custom types/structs for any part of the V1/V2 protocol to avoid handling values without meaning,
- considering using the functional style of programming. This seems appropriate e.g. for the translation proxy between the V1 and V2 versions. Proclaimed Rust's zero-cost-abstraction should allow no increase in performance costs (this can be tested),
- using _session types_ --- methods returning different _state_  `structs` so that logically invalid function calls and data flows won't occur,
- usage of 3rd party libraries and code should be limited to the absolute necessity,
- Rust's compiler is quite pedantic which can lead to handling the errors as crashes (even if meant as a temporary solution). However, such unhandled cases are strictly discouraged and each error should be handled with care (and the potential crash should be intentional),
- as a important project open-source project it should be sufficiently documented. This can be enforced by the appropriate Rust macro. However, documentation requirement won't probably be strict from the beginning as it can lead to a poor documentation (to satisfy the compiler) and be a burden in the initial phases of project implementation (also the code will change much more in the beginning leading to the need of constant documentation updates),
- versioning of the libraries will be further discussed, however, formal versions are not necessary to perform the initial phases of the implementation.

### Security

Among other goals Stratum V2 aims to significantly improve the security and privacy of pool mining. Those goals should be actively tested and discussed. And not taken for granted from the specifications.

My master's degree is in CyberSecurity therefore it's natural that I'd like to focus on not just implementing Stratum V2 reference implementation, but to focus on the security as well. As security is always a broad topic the following list is rather illustrative:

- try to put the security features to the test. This can include recording the protocol messages and testing the expected entropy of the encrypted data stream. Furthermore, encrypted messages don't guarantee complete privacy (think side-channel analysis e.g. message sizes). It should be tested that the known attacks (e.g. the ones described in [Ruben Recabarren - Hardening Stratum, the Bitcoin Pool Mining Protocol](https://www.youtube.com/watch?v=sFdeeddVEpI)) are not possible.
- use Rust features like ownership/borrowing and slicing (pointer views) to avoid unnecessary data copying (e.g. private/secret keys can reside only in one place in the memory), so the benefits are not only performance-wise (less data copying)
- Current version of the specifications use [Noise protocol](https://noiseprotocol.org). This protocol or rather protocol framework is still new, so a care and analysis will be taken in order to attempt to prevent misusing/misimplementing it. The question is whether to use one of the existing Rust implementations of Noise ([snow](https://github.com/mcginty/snow), [noise-rust](https://github.com/sopium/noise-rust)) or to implement just the portion of Noise that will be needed for Stratum. The usual pros and cons of software (in)dependencies and implementation of cryptography applies.
- general code-reviews with security in mind will be performed
- (testing the randomness of the random sources in the application (whether to do this in the runtime as well is up to a discussion))


## Supporting the deployment of Stratum V2

Talks, tutorials, screencasts, blogs reflecting the questions and topics arising from Bitcoin/Mining community. E.g. already expected blog posts topics are the benchmarking differences between V1 and V2, the security improvements or tutorials on the deployment of Mining Protocol.

## Improvements over V1 as described at Stratum V2 homepage

Stratum V2 homepage stresses out the more important points of the new protocol framework. We list them here as they show the biggest differences/improvements of Stratum V2 over V1. The improvements those features provide should be testable. The goal would be to create a test/simulation suites using the testing eco-system above to test the following points: [Bandwidth consumption](https://braiins.com/stratum-v2#bandwidth), [Server CPU load](https://braiins.com/stratum-v2#cpu), [Job distribution latency](https://braiins.com/stratum-v2#job), [Binary vs. non-binary](https://braiins.com/stratum-v2#binary), [Man-in-the-middle attack prevention](https://braiins.com/stratum-v2#man), [Empty block mining elimination](https://braiins.com/stratum-v2#empty), [Job selection](https://braiins.com/stratum-v2#job-selection), [Header-only mining](https://braiins.com/stratum-v2#header), [Multiplexing](https://braiins.com/stratum-v2#multiplexing), [Implicit work subscription](https://braiins.com/stratum-v2#implicit), [Native version rolling](https://braiins.com/stratum-v2#native), [Zero-time backend switching](https://braiins.com/stratum-v2#zero), [Different type of jobs on the same connection](https://braiins.com/stratum-v2#different).

# Appendix

Here you can find further comments.

## Version control and contributions

[Git](https://git-scm.com/download/win) will be used for version control of part of the project. A specific branch and commit plan will be probably discussed (e.g. `main`, `dev` and `feat-XX` branches). The goal is to use simple yet effective way of collaboration to encourage contributions while maintaining transparency, good code organization and stability. The specifics will be discussed in the future.  Upstream repository location is up to a debate:

- [Braiins open repositories](https://github.com/braiins/braiins/tree/bos-devel/open)?
- [Bitcoin's Github](https://wwww.github.com/bitcoin)?
- dedicated Github account like [github.com/stratum-protocol](https://www.github.com/stratum-protocol), [github.com/mining-protocol](https://www.github.com/mining-protocol) or similar?
- [Jan's](https://www.github.com/quapka) or Filippo's Github accounts?
- [Square's Github](https://wwww.github.com/square)?

The specific details (where and how to report) regarding collaboration might emerge eventually (e.g. less formal issues might be accepted at the beginning, but this can change if the number of code reviews will increase). The exemplar categories (imagine issue labels) are: `security` (e.g. exploitable bugs with varying level of severity), `protocol` (e.g. bugs in the specification), `rust` (e.g. misuse/improper use of Rust language features. Understandably, there will be overlap, but the goal is to make collaboration transparent, simple and well articulated.

An appropriate way for necessary communication about all the topics will be chosen (IRC channel, mailing-list,...). The public issue trackers are a good place for general discussions, but a dedicated messaging app might be used for more efficient communication amongst the developers working daily on Stratum V2 protocol.

## CI testing

Continuous Integration should be used and should _not depend_ on the platform used. E.g. have multiple mirrors and CI setups can be used ([Github](https://www.github.com), [Gitlab](https://www.gitlab.com)). In practice keeping separate CI setups can be difficult to maintain. For now there will be only one and alternatives (other mirrors) will be added only if needed. The simple goal is to avoid some 3rd party lock-in due to CI. All tests should be simple to run locally and therefore CI will be only a convenience wrapper around the testing process.

## Abbreviations

- [WIP] Work In Progress
- [BIP] Bitcoin Improvement Proposal
- [CI] Continuous Integration
- [PR] Pull Request
- [V1] Version 1
- [V2] Version 2

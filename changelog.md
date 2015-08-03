# Stripe-CLI Project Change Log

## 1.8.3

 - new command-line option `--expand` provides support for Stripe API expansions
   - https://stripe.com/docs/api#expanding_objects
   - stripe-ruby dependancy updated to version 1.24.0

## 1.8.2

 - bug fixes
   - it was previously possible for certain command-line arguments to be passed through to the Stripe API resulting in API exceptions.
   - creating tokens would fail for bank account type

## 1.8.1

 - new configuration option to strip nil-valued attributes from command-line output
   - use on command-line with global flag `--strip-nils`
   - or set in config-file with `strip_nils=true`
   - override config-file setting with global command-line flag `--no-strip-nils`

## 1.8.0

 - top-level `invoice_items` command
   - w/ actions: `find`, `list`, `create`, & `delete`

## 1.7.0

- new `dates` config option for specifying how dates should be displayed (`utc`, `unix`, or `local`)

## 1.6.4

 - better descriptions for ALL operations
 - Bug fix
 - update `transfers` command options
   - `--statement-description`
   - `--bank-account`
   - `--card`

## 1.6.3

 - new `dollar_amounts` config setting for toggling expected currency units between **dollars** and **cents**
 - `--no-dollar-amounts` global option flag
 - `--dollar-amounts` global option flag

## 1.6.1

 - extensive option alias support throughout, with more on the way
 - more extensive documentation in README, including subcommand descriptions. (still incomplete)
 - add TOC in README

## 1.6.0

 - token creation correctly handles credit card params in any combination of individual options and --card=key:value pairs and still collects any missing params via interactive menu.
 - any operation that accepts a credit card ID or token also accepts credit card parameters directly and incorporates the credit card interactive menu.
 - improved option descriptions in all operations of all commands

## 1.5.2

 - tack **'/Stripe-CLI vX.X.X'** onto user-agent header of every api request
   - **Disclaimer:** though I believe it to be completely harmless in this instance, this feature involves monkey-patching the `Stripe` module with an `alias_method_chain` style wrapper around `Stripe#request_headers`
   - The Stripe Dashboard depends on the user-agent to distinguish the **source** of each api request
   - this helps differentiate between requests made by application code and those made using the Stripe-CLI gem


## 1.5.1

 - fix unreported bug where Stripe::ListObjects were not displayed as simple arrays by awesome_print
   - only present in conjunction with stripe-ruby version 1.14 and up
   - due to a change in stripe-ruby by which `Stripe::StripeObject#to_hash` now calls itself recursivly
   - resort to using `Object#instance_variable_get` to peek at a StripeObject's `@values` variable which already contains a hash of its attributes
     - I am open to suggestions for a less brittle solution

## 1.5.0

 - Refunds as a top-level command

## 1.4.6

 - subscriptions `reactivate` subcommand
 - `--at-period-end` flag added to `subscriptions cancel`
 - `--refund-application-fee` flag added to `charges refund`
 - add `--metadata` to the remaining subcommands that need it

## 1.4.4

 - `--receipt_email` and `--statement_description` options added to `charges create`

## 1.4.3

 - top-level `version` command for printing current gem version
   - hidden from standard `help` banner
   - aliased as `-v` and `--version`

## 1.4.1

 - per project config files (.stripecli)

## 1.4.0

 - credit cards as a top-level command
   - for customers and recipients
   - w/ actions: find, list, create, & delete

## 1.3.0

  - introduce multiple subscriptions per customer
    - w/ actions: cancel, create, find, & list

## 1.2.2

  - introduce optional cursor-based pagination options to all `list` operations
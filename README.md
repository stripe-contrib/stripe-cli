<a href="http://badge.fury.io/rb/stripe-cli"><img style="float:right;" src="https://badge.fury.io/rb/stripe-cli.png" alt="Gem Version" height="18"></a>
<a href="https://codeclimate.com/repos/52773e8fc7f3a3121a004455/feed"><img style="float:right;margin-right:10px;" src="https://codeclimate.com/repos/52773e8fc7f3a3121a004455/badges/67e5d04281479d6f8cb3/gpa.png"></a>
# Stripe::CLI
stripe-cli is the command line interface to [Stripe](https://stripe.com).

Offering a friendly, intuitive interface to the entire API via a git-style command suite.

With an emphasis on convenience and productivity and a commitment to pretty, colorful, but most of all READABLE output.


Uses [AwesomePrint](https://github.com/michaeldv/awesome_print) to provide very readable output on your command line.

![example output](./output.png)

Note that Date/Time stamps are converted automatically.  No more Epoch/Unix timestamp garbage!

## Installation

    $ gem install stripe-cli

## Configuration

For authentication, pass your secret key using the `-k` or `--key` option

    $ stripe events list -k sk_test_abcdef123456

To use a specific api version, pass in the `-v` or `--version` option

    $ stripe balance_transactions list -v "2014-08-04"

You may also store default configurations in a `~/.stripecli` file that conforms to the following example

![example config file](./example.png)

If this file exists, the specified default key is picked up and used automatically.

The current directory is now also checked for the existance of a `.stripecli` file. In which case, that file is used instead.

You may also overide the default environment setting in your config file by passing in the `-e` or `--env` option

    $ stripe customers find cust_123 --env=live

If you manage separate Stripe accounts for several projects, I suggest creating a simple `.stripecli` file
at the root of each project declaring the test api key for the appropriate Stripe account.

For example `./.stripecli`:

    key = sk_test_abcdef123456

or, if you'd rather:

    default = test
    [test]
      key = sk_test_abcdef123456
    [live]
      key = sk_live_ghijkl789101

If you choose to go this route, make sure to add `.stripecli` to your `.gitignore` files.

## General Features & Flexibility

Any parameters accepted by the [stripe api](https://stripe.com/docs/api) are acceptable options to pass into commands, including metadata.

    $ stripe charges create  --amount=0998  --description=a\ must\ have  --number=4242424242424242  --cvc=123  --exp-month=10  --exp-year=2020

or

    $ stripe charges create  --amount=1672  --token=tok_abc123  --metadata=foo:bar meta:really\ meta\ data

or

    $ stripe charges create  --amount=100  --customer=cus_def456  --no-capture

### Interactive Menus

Passing NO (or partial) arguments to any operation, will trigger an interactive menu

    $ stripe charge create
    Amount in dollars: __

or

    $ stripe charge create  --amount=9900
    Name on Card: __

or

    $ stripe token create card --card=number:4242424242424242 name:Uther\ Pendragon cvc:911 exp-month:02
    Expiration Year: __

### cursor-based pagination

for all `list` operations

    Options:
      [--starting-after=OBJECT_ID]  # The ID of the last object in the previous paged result set.
      [--ending-before=OBJECT_ID]   # The ID of the first object in the previous paged result set, when paging backwards through the list.
      [--limit=LIMIT]               # a limit on the number of resources returned, between 1 and 100


Though Stripe advocates using cursor-based pagination, offset-based pagination is still supported.

e.g. fetching a second page

    stripe events list --count=10 --offset=10

### Exception Recovery

Api errors are rescued and their messages displayed for you to read.  No more `barfing` to `stdout`

![error rescue example](./error_message_display.png)

## Usage

    Commands:
      stripe balance         # show currently available & pending balance amounts
      stripe cards           # find, list, create, & delete cards for both customers & recipients
      stripe charges         # find, list, create, capture, & refund charges
      stripe coupons         # find, list, create, & delete coupons
      stripe customers       # find, list, create, & delete customers
      stripe events          # find & list events
      stripe help [COMMAND]  # Describe available commands or one specific command
      stripe invoices        # find, list, pay, & close invoices
      stripe plans           # find, list, create, & delete plans
      stripe recipients      # find, list, create, & delete recipients
      stripe refunds         # find, list, & create refunds
      stripe subscriptions   # find, list, create, cancel, & reactivate multiple subscriptions per customer
      stripe tokens          # find & create tokens for bank accounts & credit cards
      stripe transactions    # find & list balance transactions
      stripe transfers       # find, list, & create transfers


## Command Documentation

- [Charges](#charges)
    - [Capture](#charge-capture)
    - [Create](#charge-create)
    - [Find](#charge-find)
    - [List](#charges-list)
    - [Refund](#charge-refund)
- [Tokens](#tokens)
    - [Create](#token-create)
    - [Find](#token-find)
- [Cards](#cards)
    - [Create](#card-create)
    - [Delete](#card-delete)
    - [Find](#card-find)
    - [List](#cards-list)
- [Customers](#customers)
    - [Create](#customer-create)
    - [Delete](#customer-delete)
    - [Find](#customer-find)
    - [List](#customers-list)
- [Subscriptions](#subscriptions)
    - [Cancel](#subscription-cancel)
    - [Create](#subscription-create)
    - [Find](#subscription-find)
    - [List](#subscriptions-list)
    - [Reactivate](#subscription-reactivate)
- [Invoices](#invoices)
    - [Close](#invoice-close)
    - [Find](#invoice-find)
    - [List](#invoices-list)
    - [Pay](#invoice-pay)
    - [Upcoming](#invoice-upcoming)
- [Plans](#plans)
    - [Create](#plan-create)
    - [Delete](#plan-delete)
    - [Find](#plan-find)
    - [List](#plans-list)
- [Coupons](#coupons)
    - [Create](#coupon-create)
    - [Delete](#coupon-delete)
    - [Find](#coupon-find)
    - [List](#coupons-list)
- [Events](#events)
    - [Find](#event-find)
    - [List](#events-list)
- [BalanceTransactions](#balancetransactions)
    - [Find](#transaction-find)
    - [List](#transactions-list)
- [Recipients](#recipients)
    - [Create](#recipient-create)
    - [Delete](#recipient-delete)
    - [Find](#recipient-find)
    - [List](#recipients-list)
- [Refunds](#refunds)
    - [Create](#refund-create)
    - [Find](#refund-find)
    - [List](#refunds-list)
- [Transfers](#transfers)
    - [Create](#transfer-create)
    - [Find](#transfer-find)
    - [List](#transfers-list)

<!-- end toc -->


### Charges

    Commands:
      stripe charges capture ID      # Capture a charge
      stripe charges create          # Create a charge
      stripe charges find ID         # Find a charge
      stripe charges help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe charges list            # List charges (optionally by customer_id)
      stripe charges refund ID       # Refund a charge

#### Charge Capture

    Usage:
      stripe charges capture ID

#### Charge Create

    Usage:
      stripe charges create

    Options:
          [--customer=CUSTOMER]                           # The ID of an existing customer to charge
          [--token | --card=CARD]                         # credit card Token or ID. May also be created interactively.
          [--number | --card-number=CARD_NUMBER]          # credit card number. usually 16 digits long
          [--exp-month | --card-exp-month=CARD_EXP_MONTH] # Two digit expiration month of card
          [--exp-year | --card-exp-year=CARD_EXP_YEAR]    # Four digit expiration year of card
          [--cvc | --card-cvc=CARD_CVC]                   # Three or four digit security code located on the back of card
          [--name | --card-name=CARD_NAME]                # Cardholder's full name as displayed on card
          [--amount=N]                                    # Charge amount in dollars
          [--currency=CURRENCY]                           # 3-letter ISO code for currency
                                                          # Default: usd
          [--description=DESCRIPTION]                     # Arbitrary description of charge
          [--capture], [--no-capture]                     # Whether or not to immediately capture the charge. Uncaptured charges expire in 7 days
                                                          # Default: true
          [--metadata=key:value]                          # A key/value store of additional user-defined data
          [--statement-description=STATEMENT_DESCRIPTION] # Displayed alongside your company name on your customer's card statement (15 character max)
          [--receipt-email=RECEIPT_EMAIL]                 # Email address to send receipt to. Overrides default email settings.

#### Charge Find

    Usage:
      stripe charges find ID

#### Charges List

    Usage:
      stripe charges list

    Options:
          [--starting-after=STARTING_AFTER]  # The ID of the last object in the previous paged result set. For cursor-based pagination.
          [--ending-before=ENDING_BEFORE]    # The ID of the first object in the previous paged result set, when paging backwards through the list.
          [--limit=LIMIT]                    # a limit on the number of resources returned, between 1 and 100
          [--offset=OFFSET]                  # the starting index to be used, relative to the entire list
          [--count=COUNT]                    # depricated: use limit
          [--customer=CUSTOMER]              # a customer ID to filter results by

#### Charge Refund

    Usage:
      stripe charges refund ID

    Options:
          [--amount=N]                                               # Refund amount in dollars. (Entire charge by default)
          [--metadata=key:value]                                     # a key/value store of additional user-defined data
          [--refund-application-fee], [--no-refund-application-fee]  # Whether or not to refund the application fee


### Tokens

    Commands:
      stripe tokens create TYPE     # Create a new token of type TYPE(card or account)
      stripe tokens find ID         # Find a Token
      stripe tokens help [COMMAND]  # Describe subcommands or one specific subcommand

#### Token Create

    Usage:
      stripe token create TYPE

    Options:
          [--card=key:value]                              # hash of card params. params may also be provided individually or added interactively.
          [--number | --card-number=CARD_NUMBER]          # credit card number. usually 16 digits long
          [--exp-month | --card-exp-month=CARD_EXP_MONTH] # Two digit expiration month of card
          [--exp-year | --card-exp-year=CARD_EXP_YEAR]    # Four digit expiration year of card
          [--cvc | --card-cvc=CARD_CVC]                   # Three or four digit security code located on the back of card
          [--name | --card-name=CARD_NAME]                # Cardholder's full name as displayed on card
          [--account | --bank-account=key:value]          # hash of account params. params may also be provided individually or added interactively.
          [--country=COUNTRY]
          [--routing-number=ROUTING_NUMBER]
          [--account-number=ACCOUNT_NUMBER]

#### Token Find

    Usage:
      stripe token find ID


### Cards

    Commands:
      stripe cards create --owner=OWNER     # Create a new card for OWNER (customer or recipient)
      stripe cards delete ID --owner=OWNER  # Delete ID card for OWNER (customer or recipient)
      stripe cards find ID --owner=OWNER    # Find ID card for OWNER (customer or recipient)
      stripe cards help [COMMAND]           # Describe subcommands or one specific subcommand
      stripe cards list --owner=OWNER       # List cards for OWNER (customer or recipient)

#### Card Create

    Usage:
      stripe card create --customer, --recipient, --owner=OWNER

    Options:
          [--token | --card=CARD]                     # credit card Token or ID. May also be created interactively.
          [--number | --card-number=CARD_NUMBER]
          [--exp-month | --card-exp-month=EXP_MONTH]  # Two digit expiration month of card
          [--exp-year | --card-exp-year=EXP_YEAR]     # Four digit expiration year of card
          [--cvc | --card-cvc=CARD_CVC]               # Three or four digit security code located on the back of card
          [--name | --card-name=CARD_NAME]            # Cardholder's full name as displayed on card
          --customer, --recipient, --owner=OWNER      # id of customer or recipient receiving new card

#### Card Delete

    Usage:
      stripe card delete ID --owner=OWNER

    Options:
          --owner=OWNER       # id of customer or recipient to search within

#### Card Find

    Usage:
      stripe card find ID --owner=OWNER

    Options:
          --owner=OWNER       # id of customer or recipient to search within

#### Cards List

    Usage:
      stripe cards list --owner=OWNER

    Options:
          [--starting-after=STARTING_AFTER]  # The ID of the last object in the previous paged result set. For cursor-based pagination.
          [--ending-before=ENDING_BEFORE]    # The ID of the first object in the previous paged result set, when paging backwards through the list.
          [--limit=LIMIT]                    # a limit on the number of resources returned, between 1 and 100
          [--offset=OFFSET]                  # the starting index to be used, relative to the entire list
          [--count=COUNT]                    # depricated: use limit
          --owner=OWNER                      # id of customer or recipient to search within

### Customers

    Commands:
      stripe customers create          # Create a new customer
      stripe customers delete ID       # Delete a customer
      stripe customers find ID         # Find a customer
      stripe customers help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe customers list            # List customers

#### Customer Create

    Usage:
      stripe customer create

    Options:
          [--description=DESCRIPTION]                     # Arbitrary description to be displayed in Stripe Dashboard.
          [--email=EMAIL]                                 # Customer's email address. Will be displayed in Stripe Dashboard.
          [--plan=PLAN]                                   # The ID of a Plan this customer should be subscribed to. Requires a credit card.
          [--coupon=COUPON]                               # The ID of a Coupon to be applied to all of Customer's recurring charges
          [--quantity=QUANTITY]                           # A multiplier for the plan option. defaults to `1'
          [--trial-end=TRIAL_END]                         # apply a trial period until this date. Override plan's trial period.
          [--account-balance=ACCOUNT_BALANCE]             # customer's starting account balance in cents. A positive amount will be added to the next invoice while a negitive amount will act as a credit.
          [--token | --card=CARD]                         # credit card Token or ID. May also be created interactively.
          [--number | --card-number=CARD_NUMBER]          # credit card number. usually 16 digits long
          [--exp-month | --card-exp-month=CARD_EXP_MONTH] # Two digit expiration month of card
          [--exp-year | --card-exp-year=CARD_EXP_YEAR]    # Four digit expiration year of card
          [--cvc | --card-cvc=CARD_CVC]                   # Three or four digit security code located on the back of card
          [--name | --card-name=CARD_NAME]                # Cardholder's full name as displayed on card
          [--metadata=key:value]                          # a key/value store of additional user-defined data

#### Customer Delete

    Usage:
      stripe customer delete ID

#### Customer Find

    Usage:
      stripe customer find ID

#### Customers List

    Usage:
      stripe customers list

    Options:
          [--starting-after=STARTING_AFTER]  # The ID of the last object in the previous paged result set. For cursor-based pagination.
          [--ending-before=ENDING_BEFORE]    # The ID of the first object in the previous paged result set, when paging backwards through the list.
          [--limit=LIMIT]                    # a limit on the number of resources returned, between 1 and 100
          [--offset=OFFSET]                  # the starting index to be used, relative to the entire list
          [--count=COUNT]                    # depricated: use limit


### Subscriptions

    Commands:
      stripe subscriptions cancel ID --customer=CUSTOMER      # cancel ID subscription for CUSTOMER customer
      stripe subscriptions create --customer=CUSTOMER         # create a subscription for CUSTOMER customer
      stripe subscriptions find ID --customer=CUSTOMER        # find ID subscription for CUSTOMER customer
      stripe subscriptions help [COMMAND]                     # Describe subcommands or one specific subcommand
      stripe subscriptions list --customer=CUSTOMER           # List subscriptions for CUSTOMER customer
      stripe subscriptions reactivate ID --customer=CUSTOMER  # reactivate auto-renewal if `cancel-at-period-end` was set to true

#### Subscription Cancel

    Usage:
      stripe subscription cancel ID c, --customer=CUSTOMER

    Options:
          [--at-period-end], [--no-at-period-end]  # delay cancellation until end of current period
                                                   # default: false
          c, --customer=CUSTOMER                   # id of customer to search within

#### Subscription Create

    Usage:
      stripe subscription create c, --customer=CUSTOMER

    Options:
          [--plan=PLAN]                                   # the plan to assign to CUSTOMER customer
          [--coupon=COUPON]                               # id of a coupon to apply
          [--trial-end=TRIAL_END]                         # apply a trial period until this date. Override plan's trial period.
          [--token | --card=CARD]                         # credit card Token or ID. May also be created interactively.
          [--number | --card-number=CARD_NUMBER]          # credit card number. usually 16 digits long
          [--exp-month | --card-exp-month=CARD_EXP_MONTH] # Two digit expiration month of card
          [--exp-year | --card-exp-year=CARD_EXP_YEAR]    # Four digit expiration year of card
          [--cvc | --card-cvc=CARD_CVC]                   # Three or four digit security code located on the back of card
          [--name | --card-name=CARD_NAME]                # Cardholder's full name as displayed on card
          [--metadata=key:value]                          # a key/value store of additional user-defined data
          c, --customer=CUSTOMER                          # ID of customer receiving the new subscription

#### Subscription Find

    Usage:
      stripe subscription find ID c, --customer=CUSTOMER

    Options:
          c, --customer=CUSTOMER  # ID of customer to search within

#### Subscriptions List

    Usage:
      stripe subscriptions list c, --customer=CUSTOMER

    Options:
          [--starting-after=STARTING_AFTER]  # The ID of the last object in the previous paged result set. For cursor-based pagination.
          [--ending-before=ENDING_BEFORE]    # The ID of the first object in the previous paged result set, when paging backwards through the list.
          [--limit=LIMIT]                    # a limit on the number of resources returned, between 1 and 100
          [--offset=OFFSET]                  # the starting index to be used, relative to the entire list
          [--count=COUNT]                    # depricated: use limit
          c, --customer=CUSTOMER             # ID of customer to search within

#### Subscription Reactivate

    Usage:
      stripe subscription reactivate ID c, --customer=CUSTOMER

    Options:
          c, --customer=CUSTOMER  # id of customer to search within

### Invoices

    Commands:
      stripe invoices close ID           # Close an unpaid invoice
      stripe invoices find ID            # Find an invoice
      stripe invoices help [COMMAND]     # Describe subcommands or one specific subcommand
      stripe invoices list               # List invoices (optionally by customer_id)
      stripe invoices pay ID             # trigger an open invoice to be paid immediately
      stripe invoices upcoming CUSTOMER  # find the upcoming invoice for CUSTOMER

#### Invoice Close

    Usage:
      stripe invoice close ID

#### Invoice Find

    Usage:
      stripe invoice find ID

#### Invoices List

    Usage:
      stripe invoice list

    Options:
          [--starting-after=STARTING_AFTER]  # The ID of the last object in the previous paged result set. For cursor-based pagination.
          [--ending-before=ENDING_BEFORE]    # The ID of the first object in the previous paged result set, when paging backwards through the list.
          [--limit=LIMIT]                    # a limit on the number of resources returned, between 1 and 100
          [--offset=OFFSET]                  # the starting index to be used, relative to the entire list
          [--count=COUNT]                    # depricated: use limit
          [--customer=CUSTOMER]              # a customer ID to filter results by

#### Invoice Pay

    Usage:
      stripe invoice pay ID

#### Invoice Upcoming

    Usage:
      stripe invoice upcoming CUSTOMER


### Plans

    Commands:
      stripe plans create          # Create a new plan
      stripe plans delete ID       # Delete a plan
      stripe plans find ID         # Find a plan
      stripe plans help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe plans list            # List plans

#### Plan Create


#### Plan Delete


#### Plan Find


#### Plans List



### Coupons

    Commands:
      stripe coupons create          # Create a new Coupon
      stripe coupons delete ID       # Delete a coupon
      stripe coupons find ID         # Find a coupon
      stripe coupons help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe coupons list            # List coupons

#### Coupon Create


#### Coupon Delete


#### Coupon Find


#### Coupons List



### Events

    Commands:
      stripe events find ID         # Find a event
      stripe events help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe events list            # List events

#### Event Find


#### Events List



### BalanceTransactions

    Commands:
      stripe transactions find ID         # Find a transaction
      stripe transactions help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe transactions list [TYPE]     # List transactions, optionaly filter by type:(charge refund adjustment application_fee application_fee_refund transfer transfer_failure)

#### Transaction Find


#### Transactions List



### Recipients

    Commands:
      stripe recipients create          # Create a new recipient
      stripe recipients delete ID       # Delete a recipient
      stripe recipients find ID         # Find a recipient
      stripe recipients help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe recipients list            # List recipients

#### Recipient Create


#### Recipient Delete


#### Recipient Find


#### Recipients List



### Refunds

Though ```refund```  is still a supported operation of the ```charges``` command. The ```refunds``` command offers additional functionality.

    Commands:
      stripe refunds create --charge=CHARGE   # apply a new refund to CHARGE charge
      stripe refunds find ID --charge=CHARGE  # Find ID refund of CHARGE charge
      stripe refunds help [COMMAND]           # Describe subcommands or one specific subcommand
      stripe refunds list --charge=CHARGE     # List refunds for CHARGE charge

#### Refund Create


#### Refund Find


#### Refunds List



### Transfers

    Commands:
      stripe transfers create          # Create a new outgoing money transfer
      stripe transfers find ID         # Find a transfer
      stripe transfers help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe transfers list            # List transfers, optionaly filter by recipient or transfer status: ( pending paid failed )

#### Transfer Create

#### Transfer Find

#### Transfers List

#### Easter Egg

You can pass the `--balance` flag into `transfer create` to automatically set transfer `amount` equal to your currently available balance.

example:

    $ stripe transfer create --balance --recipient=self


## Road Map

1. complete command documentation in this readme
1. `update` command operations
1. support for `disputes` & dispute handling
1. support creating/updating config file through cli
1. plug-able output formating for use in scripts and such
1. request a feature you would like via the issue tracker


Pull requests are always welcome and appriciated.

Please report issues, offer suggestions, and voice concerns in the issues tracker.

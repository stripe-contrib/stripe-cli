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



you may also clone the repo and build the gem locally yourself

        $ git clone https://github.com/stripe-contrib/stripe-cli.git
        $ cd ./stripe-cli
        $ gem build stripe-cli.gemspec
        $ gem install stripe-cli

> because RubyGems looks **first** at the **current directory** before moving on to [rubygems.org](https://rubygems.org),  that last step will install the local gem you just built.



## Configuration

For authentication, pass your secret key using the `-k` or `--key` option

    $ stripe events list -k XXXXXXXXXXXXXXXXXXXXXX

To use a specific api version, pass in the `-v` or `--version` option

    $ stripe balance_transactions list -v "2013-10-29"

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

## Usage

    Commands:
      stripe balance         # show currently available and pending balance amounts
      stripe cards           # find, list, create, & delete cards for both customers & recipients
      stripe charges         # find, list, create, capture, & refund charges
      stripe coupons         # find, list, create, & delete coupons
      stripe customers       # find, list, create, & delete customers
      stripe events          # find & list events
      stripe help [COMMAND]  # Describe available commands or one specific command
      stripe invoices        # find, list, pay, and close invoices
      stripe plans           # find, list, create, & delete plans
      stripe recipients      # find, list, create & delete recipients
      stripe subscriptions   # find, list, create, cancel & reactivate multiple subscriptions per customer
      stripe tokens          # find & create tokens for bank accounts & credit cards
      stripe transactions    # find & list balance transactions
      stripe transfers       # find, list, & create transfers


Any parameters accepted by the [stripe api](https://stripe.com/docs/api) are acceptable options to pass into commands, including metadata.

    $ stripe charges create [--amount=AMOUNT][--description=DESC][--card-number=NUM][--card-cvc=CVC][--card-exp-month=MM][--card-exp-year=YYYY]

or

    $ stripe charges create [--amount=AMOUNT][--card=TOKEN_ID][--metadata=foo:bar details:"product# 4369"]

or

    $ stripe charges create [--amount=AMOUNT][--customer=CUST_ID]

### cursor-based pagination

for all ```list``` operations

    Options:
      [--starting-after=OBJECT_ID]  # The ID of the last object in the previous paged result set.
      [--ending-before=OBJECT_ID]   # The ID of the first object in the previous paged result set, when paging backwards through the list.
      [--limit=LIMIT]               # a limit on the number of resources returned, between 1 and 100


Though Stripe advocates using cursor-based pagination, offset-based pagination is still supported.

e.g. fetching a second page

    stripe events list --count=10 --offset=10


### Interactive Menus

Passing NO (or partial) arguments to any operation, will trigger an interactive menu

    $ stripe charges create
    Amount in dollars: __

or

    $ stripe charges create [--amount=AMOUNT]
    Name on Card: __

### Exception Recovery

Api errors are rescued and their messages displayed for you to read.  No more ```barfing``` to ```stdout```

![error rescue example](./error_message_display.png)

### Charges

    Commands:
      stripe charges capture ID      # Capture a charge
      stripe charges create          # Create a charge
      stripe charges find ID         # Find a charge
      stripe charges help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe charges list            # List charges
      stripe charges refund ID       # Refund a charge

### Tokens

    Commands:
      stripe tokens create TYPE     # Create a new token of type TYPE(card or account)
      stripe tokens find ID         # Find a Token
      stripe tokens help [COMMAND]  # Describe subcommands or one specific subcommand

### Cards

    Commands:
      stripe cards create --owner=OWNER     # Create a new card for OWNER (customer or recipient)
      stripe cards delete ID --owner=OWNER  # Delete ID card for OWNER (customer or recipient)
      stripe cards find ID --owner=OWNER    # Find ID card for OWNER (customer or recipient)
      stripe cards help [COMMAND]           # Describe subcommands or one specific subcommand
      stripe cards list --owner=OWNER       # List cards for OWNER (customer or recipient)

### Customers

    Commands:
      stripe customers create          # Create a new customer
      stripe customers delete ID       # Delete a customer
      stripe customers find ID         # Find a customer
      stripe customers help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe customers list            # List customers

### Subscriptions

    Commands:
      stripe subscriptions cancel ID --customer=CUSTOMER      # cancel ID subscription for CUSTOMER customer
      stripe subscriptions create --customer=CUSTOMER         # create a subscription for CUSTOMER customer
      stripe subscriptions find ID --customer=CUSTOMER        # find ID subscription for CUSTOMER customer
      stripe subscriptions help [COMMAND]                     # Describe subcommands or one specific subcommand
      stripe subscriptions list --customer=CUSTOMER           # List subscriptions for CUSTOMER customer
      stripe subscriptions reactivate ID --customer=CUSTOMER  # reactivate auto-renewal if `cancel-at-period-end` was set to true

### Invoices

    Commands:
      stripe invoices close ID           # Close an unpaid invoice
      stripe invoices find ID            # Find an invoice
      stripe invoices help [COMMAND]     # Describe subcommands or one specific subcommand
      stripe invoices list               # List invoices (optionally by customer_id)
      stripe invoices pay ID             # trigger an open invoice to be paid immediately
      stripe invoices upcoming CUSTOMER  # find the upcoming invoice for CUSTOMER

### Plans

    Commands:
      stripe plans create          # Create a new plan
      stripe plans delete ID       # Delete a plan
      stripe plans find ID         # Find a plan
      stripe plans help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe plans list            # List plans

### Coupons

    Commands:
      stripe coupons create          # Create a new Coupon
      stripe coupons delete ID       # Delete a coupon
      stripe coupons find ID         # Find a coupon
      stripe coupons help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe coupons list            # List coupons

### Events

    Commands:
      stripe events find ID         # Find a event
      stripe events help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe events list            # List events

### BalanceTransactions

    Commands:
      stripe transactions find ID         # Find a transaction
      stripe transactions help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe transactions list [TYPE]     # List transactions, optionaly filter by type: ( charge refund adjustment application_fee application_fee_refund transfer transfer_failure )

### Recipients

    Commands:
      stripe recipients create          # Create a new recipient
      stripe recipients delete ID       # Delete a recipient
      stripe recipients find ID         # Find a recipient
      stripe recipients help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe recipients list            # List recipients

### Transfers

    Commands:
      stripe transfers create          # Create a new outgoing money transfer
      stripe transfers find ID         # Find a transfer
      stripe transfers help [COMMAND]  # Describe subcommands or one specific subcommand
      stripe transfers list            # List transfers, optionaly filter by recipient or transfer status: ( pending paid failed )

#### Easter Egg Alert!

You can pass the `--balance` flag into `transfer create` to automatically set transfer `amount` equal to your currently available balance.

example:

    $ stripe transfer create --balance --recipient=self

> No, its not magic.  The `--balance` flag just triggers a 'preflight' api call to retrieve your current balance and assigns that to the `--amount` option

## Road Map

1. `update` command operations
1. support for `disputes` & dispute handling
1. support creating/updating config file through cli
1. plug-able output formating for use in scripts and such
1. request a feature you would like via the issue tracker


Pull requests are always welcome and appriciated.

Please report issues, offer suggestions, and voice concerns in the issues tracker.
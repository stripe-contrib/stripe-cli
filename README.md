# Stripe::CLI

stripe-cli is a command line interface to [Stripe](https://stripe.com).

Uses [AwesomePrint](https://github.com/michaeldv/awesome_print) to provide very readable output on your command line.

![example output](./output.png)

Note that all JSON-style epoch timestamps have been converted to **real life** DateTime stamps, your welcome!

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

    $ stripe balance_transactions list -v "2013-08-13"

You may also store default configurations in a `~/.stripecli` file that conforms to the following example

![example config file](./example.png)

You may also overide the default environment setting in your config file by passing in the `-e` or `--env` option

    $ stripe customers find cust_123 --env=live

## Usage

    $ stripe

    Commands:
      stripe balance         # show currently available and pending balance amounts
      stripe charges         # find, list, create, capture, & refund charges
      stripe coupons         # find, list, create, & delete coupons
      stripe customers       # find, list, create, & delete customers
      stripe events          # find & list events
      stripe invoices        # find, list, pay, and close invoices
      stripe plans           # find, list, create, & delete plans
      stripe recipients      # find, list, create & delete recipients
      stripe tokens          # find & create tokens for bank accounts & credit cards
      stripe transactions    # find & list balance transactions
      stripe transfers       # find, list, & create transfers


Any parameters accepted by the [stripe api](https://stripe.com/docs/api) are acceptable options to pass into commands

    $ stripe charges create [--amount=AMOUNT][--description=DESC][--card_number=NUM][--card_cvc=CVC][--card_exp_month=MM][--card_exp_year=YYYY]

or

    $ stripe charges create [--amount=AMOUNT][--card=TOKEN_ID]

or

    $ stripe charges create [--amount=AMOUNT][--customer=CUST_ID]

## uniform behavior

The Stripe API is very consistant. Consistency makes using the api intuitive. This utility strives to maintain Stripe's consistency. Depending on which [C.R.U.D.](http://wikipedia.org/wiki/Create,_read,_update_and_delete) operation you are after, you can pretty much count on a few standard options to be available.

### stripe (subcommand) list ...

specify how many results, between 1 and 100, should be returned (default is 10)

    ... list [--count=COUNT]

specify the starting index for this result set, relative to the entire result set (usefull in combination with `--count` for paginating results)

    ... list [--offset=OFFSET]

Passing NO (or partial) arguments, will trigger an interactive menu

    $ stripe charges create
    Amount in dollars: __

or

    $ stripe charges create [--amount=AMOUNT]
    Name on Card: __

### Charges

    $ stripe charges list
    $ stripe charge find ch_123
    $ stripe charge refund ch_123
    $ stripe charge capture ch_123
    $ stripe charge create

### Tokens

    $ stripe token find tok_123
    $ stripe token create TYPE (bank_account or credit_card)

### Customers

    $ stripe customers list
    $ stripe customer find cust_123
    $ stripe customer delete cust_123
    $ stripe customer create

### Invoices

    $ stripe invoices list [--customer=CUST_ID]
    $ stripe invoice find inv_123
    $ stripe invoice close inv_123
    $ stripe invoice pay inv_123
    $ stripe invoice upcoming cust_123

### Plans

    $ stripe plans list
    $ stripe plan find custom_plan_id
    $ stripe plan delete custom_plan_id
    $ stripe plan create

### Coupons

    $ stripe coupons list
    $ stripe coupon find 25_off
    $ stripe coupon delete 25_off
    $ stripe coupon create

### Events

    $ stripe events list
    $ stripe event find ev_123

### BalanceTransactions

    $ stripe transactions list [--type=TYPE][--source=SOURCE_ID]
    $ stripe transaction find trx_123

### Recipients

    $ stripe recipients list [--verified]
    $ stripe recipient find recip_123
    $ stripe recipient delete recip_123
    $ stripe recipient create

### Transfers

    $ stripe transfers list [--recipient=RECIPIENT_ID][--status=STATUS]
    $ stripe transfer find trans_id
    $ stripe transfer create

#### Easter Egg Alert!

You can pass the `--balance` flag into `transfer create` to automatically set transfer `amount` equal to your currently available balance.

example:

    $ stripe transfer create --balance --recipient=self

> No, its not magic.  The `--balance` flag just triggers a 'preflight' api call to retrieve your current balance and assigns that to the `--amount` option

## Road Map

1. test coverage, test coverage, test coverage!
1. `--date` filters for all `list` operations
1. `update` command operations
1. support for `disputes` & dispute handling
1. support creating/updating config file through cli
1. plug-able output formating for use in scripts and such
1. request a feature you would like via the issue tracker


pull requests welcome

report issues in the issues tracker
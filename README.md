# Stripe::CLI

stripe-cli is a command line interface to [Stripe](https://stripe.com).

## Installation

    $ gem install stripe-cli

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
        stripe balance_transaction  # /balance_transactions
        stripe charges              # /charges
        stripe customers            # /customers
        stripe events               # /events
        stripe plans                # /plans
        stripe coupons              # /coupons
        stripe invoices             # /invoices

Any parameters available in the stripe api are acceptable options to pass into commands

    $ stripe charges create [--amount=AMOUNT][--description=DESC][--card_number=NUM][--card_cvc=CVC]

Passing in NO options, will trigger an interactive menu

    $ stripe charges create
    Amount in dollars: __

### Charges

    $ stripe charges list [--count=COUNT][--offset=OFFSET]
    $ stripe charges find ch_123
    $ stripe charges refund ch_123
    $ stripe charges capture ch_123
    $ stripe charges create

### Customers

    $ stripe customers list [--count=COUNT][--offset=OFFSET]
    $ stripe customers find cust_123
    $ stripe customers delete cust_123
    $ stripe customers create

### Invoices

    $ stripe invoices list [--count=COUNT][--offset=OFFSET][--customer=CUST_ID]
    $ stripe invoices find inv_123
    $ stripe invoices close inv_123
    $ stripe invoices pay inv_123

### Plans

    $ stripe plans list [--count=COUNT][--offset=OFFSET]
    $ stripe plans find custom_plan_id
    $ stripe plans delete custom_plan_id
    $ stripe plans create

### Coupons

    $ stripe coupons list [--count=COUNT][--offset=OFFSET]
    $ stripe coupons find 25_off
    $ stripe coupons delete 25_off
    $ stripe coupons create

### Events

    $ stripe events list [--count=COUNT][--offset=OFFSET]
    $ stripe events find ev_123

### BalanceTransactions

    $ stripe balance_transactions list [--count=COUNT][--offset=OFFSET]
    $ stripe balance_transactions find trx_123

more to come soon

pull requests welcome

report issues in the issues tracker

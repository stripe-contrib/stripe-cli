# Stripe::CLI

stripe-cli is a command line interface to [Stripe](https://stripe.com).

## Installation

    $ gem install stripe-cli

## Configuration

For authentication, pass your secret key using the `-k` of `--key` option

To use a specific api version, pass in the `-v` or `--version` option

You may also store default configurations in a `~/.stripecli` file that conforms to the following example

![example config file](./example.png)

You may also overide the default environment setting in your config file by passing in the `-e` or `--env` option

## Usage

    $ stripe

      Commands:
        stripe balance_transaction  # /balance_transactions
        stripe charges              # /charges
        stripe customers            # /customers
        stripe events               # /events
        stripe plans                # /plans

    $ stripe charges list
    $ stripe charges find ch_123
    $ stripe charges refund ch_123
    $ stripe charges create
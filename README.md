# Stripe::CLI

stripe-cli is a command line interface to [Stripe](https://stripe.com).

## Installation

    $ gem install stripe-cli

For authentication, either pass your secret key using the `-k` option, or create a `~/.stripecli` file containing:

    key = sk_your_key

## Usage

  $ stripe

    Commands:
      stripe charges         # /charges
      stripe customers       # /customers
      stripe events          # /events
      stripe plans           # /plans

  $ stripe charges list
  $ stripe charges find ch_123
  $ stripe charges refund ch_123
  $ stripe charges create
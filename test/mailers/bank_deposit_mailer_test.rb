require 'test_helper'

class BankDepositMailerTest < ActionMailer::TestCase

  # enable email sending
  setup do
    @scout = scouts(:site_sales_admin)
    @ledger = Ledger.new(amount: -10, is_bank_deposit: true, account_id: accounts(:site_sale_cash).id, date: Date.today )
    @sibling_ledger = Ledger.new(amount: 10, is_bank_deposit: true, account_id: accounts(:site_sale_cash).id, date: Date.today )
  end


  test "confirmation email to bank depositer" do
    # create the email and store for testing
    email = BankDepositMailer.send_confirmation_email_to_depositer(@scout.id, @ledger, @sibling_ledger)

    # send and check queue
    assert_emails 1 do
      email.deliver_now
    end

    # test the body
    assert_equal ['from_email@example.com'], email.from
    assert_equal ["site_sales@example.com"], email.to
    assert_equal "Thank you for making a #{@scout.unit.name} deposit", email.subject
    assert_equal read_fixture('send_confirmation_email_to_depositer').join, email.body.to_s

  end

  test "confirmation email to treasurer" do
    # create the email and store for testing
    email = BankDepositMailer.send_confirmation_email_to_treasurer(@scout.id, @ledger, @sibling_ledger)

    # send and check queue
    assert_emails 1 do
      email.deliver_now
    end

    # test the body
    assert_equal ['from_email@example.com'], email.from
    assert_equal ["paul@example.com"], email.to
    assert_equal "A #{Rails.configuration.application_name} bank deposit was made from Site Sales cash", email.subject
    assert_equal read_fixture('send_confirmation_email_to_treasurer').join, email.body.to_s

  end

end
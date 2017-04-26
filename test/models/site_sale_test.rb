require 'test_helper'

class SiteSaleTest < ActiveSupport::TestCase

  setup do
    @site_sale = SiteSale.new(site_sales(:one))
  end

end
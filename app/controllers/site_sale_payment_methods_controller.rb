class SiteSalePaymentMethodsController < ApplicationController
  before_action :set_site_sale
  
  def new
    @site_sale_payment_method = @site_sale.site_sale_payment_methods.build
    @accounts = @active_event.accounts.is_site_sale_eligible.where.not(id: used_method_ids).order(:name)
  end

  def edit
    @site_sale_payment_method = @site_sale.site_sale_payment_methods.find(params[:id])
    modified_used_method_id = used_method_ids - [@site_sale_payment_method.account_id]
    @accounts = @active_event.accounts.is_site_sale_eligible.where.not(id: modified_used_method_id).order(:name)
  end

  def update
    @site_sale_payment_method = @site_sale.site_sale_payment_methods.find(params[:id])

    respond_to do |format|
      if @site_sale_payment_method.update(site_sale_payment_method_params)
        format.html { redirect_to @site_sale  }
      else
        @accounts = @active_event.accounts.is_site_sale_eligible.where.not(id: used_method_ids).order(:name)
        format.html { render :edit }
      end
    end
  end

  def create
    @site_sale_payment_method = @site_sale.site_sale_payment_methods.build(site_sale_payment_method_params)
    if @site_sale_payment_method.save
      redirect_to @site_sale, notice: 'Form of Site Sale payment was added'
    else
      @accounts = @active_event.accounts.is_site_sale_eligible.where.not(id: used_method_ids).order(:name)
      render :new
    end
  end

  def destroy
    @site_sale_payment_method = @site_sale.site_sale_payment_methods.find(params[:id])
    @site_sale_payment_method.destroy
    redirect_to @site_sale
  end

  private

  def set_site_sale
    @site_sale = SiteSale.find(params[:site_sale_id])
  end

  def site_sale_payment_method_params
    params.require(:site_sale_payment_method).permit(:account_id, :amount)
  end

  def used_method_ids
    @site_sale.site_sale_payment_methods.map {|sspm| sspm.account_id }
  end

end

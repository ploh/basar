SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :home, t('layouts.application.home'), root_path
    if current_user
      primary.item :account, t('layouts.application.account'), edit_user_registration_path
    end

    primary.item :selling, t('layouts.application.selling'), pages_selling_path do |selling|
      selling.item :faq, t('layouts.application.faq'), pages_faq_path
      selling.item :help, 'Helfen', pages_selling_help_path
      if current_user && current_user.seller
        selling.item :edit_seller, 'Termine wählen', edit_seller_path(current_user.seller)
      else
        selling.item :register, 'Anmelden', sellers_apply_path
      end
    end
    primary.item :presell, t('layouts.application.presell'), pages_presell_path do |presell|
      presell.item :cake, 'Essen', pages_presell_cake_path do |presell_cake|
        unless current_user && current_user.seller
          presell_cake.item :register, 'Anmelden', sellers_cake_path
        end
      end
      presell.item :help, 'Helfen', pages_presell_help_path do |presell_help|
        unless current_user && current_user.seller
          presell_help.item :register, 'Anmelden', sellers_help_path
        end
      end
    end
  end
end

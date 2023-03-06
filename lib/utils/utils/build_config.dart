// ignore_for_file: recursive_getters, non_constant_identifier_names, prefer_const_declarations

import 'package:BBQOUTLETS/Constants/ConstantVariables.dart';

class BuildConfig {
  /*--------------------------------*/

  // String? categories_value=ConstantsVar.prefs.getInt("subcategories").toString();

  //  int categories_value=139;
  static var categoriesvalue =
      ConstantsVar.prefs.getInt("subcategories").toString();

  // static var categoriesvalue=_instance;
//  static  get categoriesvalue => ConstantsVar.prefs.getInt("subcategories").toString();

  static final String base_url_magento_api =
      'https://magento-561260-1838674.cloudwaysapps.com/rest/V1/integration/customer/token';

  // static final String magento_product_url='https://magento-561260-1838674.cloudwaysapps.com/rest/V1/products?searchCriteria[filter_groups][0][filters][0][field]=category_id& searchCriteria[filter_groups][0][filters][0][value]=$categoriesvalue& searchCriteria[filter_groups][0][filters][0][condition_type]=eq&searchCriteria[pageSize]=40';
  static final String magentoBaseUrl =
      'https://magento-561260-1838674.cloudwaysapps.com/rest/V1';
  static final String magentoBaseUrltwo =
      '/products?searchCriteria[filter_groups][0][filters][0][field]=category_id& searchCriteria[filter_groups][0][filters][0][value]=';
  static final String magentoBaseUrlthree =
      '& searchCriteria[filter_groups][0][filters][0][condition_type]=eq&searchCriteria[pageSize]=40';
  static final String magenot_add_product_cart =
      "https://magento-561260-1838674.cloudwaysapps.com/rest/V1/carts/mine/items";
  static final String magenot_show_cart_addProduct =
      "https://magento-561260-1838674.cloudwaysapps.com/rest/V1/guest-carts//totals";

  /*--------------------------------*/

  static final String base_url = 'https://www.theone.com/';
  static final String base_url_for_apis = 'www.theone.com';

  static final String banners = 'apis/GetBanners';
  static final String token_url = 'token/GetToken';
  static final String remove_cart_item_url = 'customer/RemoveCartItems';
  static final String apply_coupon_url = 'apis/ApplyCoupon';
  static final String remove_coupon_url = 'apis/RemoveCoupon';
  static final String gift_card_url = 'apis/ApplyGiftCard';
  static final String remove_gift_card_url = 'apis/RemoveGiftCard';
  static final String all_address_url = 'apis/GetCustomerAddressList';
  static final String billing_address = 'apis/GetBillingAddresses';
  static final String select_billing_address = 'apis/SelectBillingAddress';
  static final String get_shipping_address_url = 'apis/GetShippingAddresses';
  static final String select_shipping_address_url =
      'apis/SelectShippingAddress';
  static final String add_select_shipping_address_url =
      'apis/AddSelectNewShippingAddress';
  static final String show_order_summary_url = 'apis/GetOrderSummary';
  static final String update_cart_url = 'apis/UpdateCart';

  static final String edit_address = "Customer/EditAddress";

  static var countryCode = '971';
  static final apiTokenx =
      'e9e3cb11b67dd0d8646d8e437274061ed537803b281e45a504321cafcdb7218a';

  static var uaeCountryCode = '+971';
  static const phnVal = 9;

  static final String delete_address = 'customer/DeleteCustomerAddress';

  static get _instance => _instance;

/*Future getApiToken() async {
    ConstantsVar.prefs = await SharedPreferences.getInstance();
    return ConstantsVar.prefs.getInt("subcategories").toString();
  }*/

}

const String magentoBaseUrl =
    'https://magento-561260-2500518.cloudwaysapps.com/rest/V1/';
const String homeTag = 'HomeLogo';
const String noImageUrl =
    'https://us.123rf.com/450wm/urfandadashov/urfandadashov1806/urfandadashov180601827/150417827-photo-not-available-vector-icon-isolated-on-transparent-background-photo-not-available-logo-concept.jpg?ver=6';
const String logoImage = 'BBQ_Images/bbqologomaster.png';
const String logoTag = 'logoTag';
const String logoTag1 = 'logoTag1';
const String logoProductTag = 'productTag';

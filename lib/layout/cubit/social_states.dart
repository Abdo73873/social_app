

abstract class ShopStates {}

class ShopInitializeState extends ShopStates {}

class ShopChangeBottomState extends ShopStates {}

class ShopChangeLanguageState extends ShopStates {}

class ShopLoadingHomeState extends ShopStates {}

class ShopSuccessHomeState extends ShopStates {}

class ShopErrorHomeState extends ShopStates {
  final String error;
  ShopErrorHomeState(this.error);
}
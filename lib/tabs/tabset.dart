library bootstrap.ui.tabs;

import 'package:angular/angular.dart';
import 'dart:html';
import 'package:angular_dart_ui_bootstrap/core/BaseComponent.dart';

part 'tab.dart';
part 'tabHeading.dart';

class TabsetModule extends Module {
  TabsetModule() {
    type(TabsetComponent);
    type(TabComponent);
    type(TabHeadingTranscludeComponent);
  }
}

@NgComponent(
    selector: 'tabset',
    visibility: NgDirective.DIRECT_CHILDREN_VISIBILITY,
    template:
'''
<div class="tabbable">
  <ul class="nav nav-tabs" ng-class="{'nav-stacked': tabsetCtrl.vertical, 'nav-justified': tabsetCtrl.justified}">
    <li ng-repeat="tab in tabsetCtrl.tabs" ng-class="{active: tab.active, disabled: tab.disabled}">
      <a ng-click="tabsetCtrl.select(tab)"><tab-heading-transclude tab="tab"></tab-heading-transclude></a>
    </li>
  </ul>
  <div class="tab-content">
    <content></content>
  </div>
</div>
''',
    publishAs: 'tabsetCtrl',
    applyAuthorStyles: true,
    map: const {
      'vertical': '=>vertical',
      'justified': '=>justified'
    }
)
class TabsetComponent extends BaseComponent {
  
  bool justified = false;
  bool vertical = false;
  List<TabComponent> tabs = [];
  
  TabsetComponent(Element element) : super(element) {
  }

  void select(TabComponent tab) {
    tabs.forEach((tab) {
      tab.active = false;
    });
    tab.active = true;
  }

  void addTab(TabComponent tab) {
    tabs.add(tab);
    if (tabs.length == 1 || tab.active) {
      select(tab);
    }
  }

  void removeTab(TabComponent tab) {
    int index = tabs.indexOf(tab);
    //Select a new tab if the tab to be removed is selected
    if (tab.active && tabs.length > 1) {
      //If this is the last tab, select the previous tab. else, the next tab.
      int newActiveIndex = index == tabs.length - 1 ? index - 1 : index + 1;
      select(tabs[newActiveIndex]);
    }
    tabs.remove(tab);
  }
  
}
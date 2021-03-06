// Copyright 2014 Francesco Cina
// http://angular-dart-ui.github.io/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0

library bootstrap.ui.dropdownToggle;

import 'dart:html';
import 'package:angular/angular.dart';

class DropdownToggleModule extends Module {
  DropdownToggleModule() {
    type(DropdownService);
    type(DropdownDirective);
    type(DropdownToggleDirective);
  }
}

@NgInjectableService()
class DropdownService {
  
  DropdownDirective currentOpenedDropdown;
  
  void notifyOpen(DropdownDirective openDropdown) {
    if (currentOpenedDropdown!=null && currentOpenedDropdown != openDropdown) {
      currentOpenedDropdown.isOpen = false;
    }
    currentOpenedDropdown = openDropdown;
  }
  
  void notifyClose(DropdownDirective dropdownDirective) {
    if (currentOpenedDropdown == dropdownDirective) {
      currentOpenedDropdown = null;
    }
  }
  
}


@NgDirective(
    selector: '.dropdown',
    visibility: NgDirective.DIRECT_CHILDREN_VISIBILITY
)
class DropdownDirective implements NgDetachAware {
  
  final Element element;
  final DropdownService dropdownService;
  EventListener onClickListener;
  EventListener onKeyDownListener;
  bool open = false;
  
  DropdownDirective(this.element, this.dropdownService) {
    onClickListener = (MouseEvent event) {
      this.isOpen = false;
    };
    onKeyDownListener = (KeyboardEvent event) {
      if ( event.keyCode == 27 ) {
        this.isOpen = false;
      }
    };
  }
  
  get isOpen => open;
  
  set isOpen(bool open) {
    this.open = open;
    element.classes.toggle('open', open);
    if (open) {
      dropdownService.notifyOpen(this);
      window.document.addEventListener('click', onClickListener, false);
      window.document.addEventListener('keydown', onKeyDownListener);
    } else {
      dropdownService.notifyClose(this);
      window.document.removeEventListener('click', onClickListener);
      window.document.removeEventListener('keydown', onKeyDownListener);
    }
  }

  void detach() {
    isOpen = false;
  }
}

@NgDirective(
    selector: '.dropdown-toggle'
)
class DropdownToggleDirective {
  
  final Element element;
  final DropdownDirective dropdown;
  
  DropdownToggleDirective(this.element, this.dropdown) {
    element.onClick.listen((event) { 
      event.preventDefault();
      event.stopPropagation();
      dropdown.isOpen = !dropdown.isOpen;
    });
  }
  
}
library alert_test;

import '../_specs.dart';
import '../../web/main.dart';

main() {
  
  String HTML = "<div test-div>" + 
      "<alert ng-repeat='alert in alerts' type='alert.type' close='onCloseCallback(\$index)'>{{alert.msg}}</alert>" +
    "</div>";
  
  List<Map> alerts = [
                     { 'msg':'foo', 'type':'success'},
                     { 'msg':'bar', 'type':'error'},
                     { 'msg':'baz'}
                     ];
  
  
  group('alert shadow dom options', () {
    
    Compiler $compile;
    Scope $rootScope;
    Injector injector;
    
    Element findAlert(Element elem, int index) {
      return elem.children[index].shadowRoot.querySelector('.alert');
    }
    
    Element findCloseButton(Element elem, int index) {
      return elem.children[index].shadowRoot.querySelector('.close');
    }

    setUp(() {
      setUpInjector();
      module((Module module) {
        module.install(new MyAppModule());
      });
      inject((
            Compiler _compile, Scope _rootScope, Injector _injector) {
          $compile = _compile; $rootScope = _rootScope; injector = _injector;
      });
    });
    
    tearDown(tearDownInjector);
  
    test('should render a simple alert', async(inject(() {

      $rootScope.alert = { 'msg':'foo', 'type':'success'};
      String html = "<div test-div>" + 
          "<alert type='alert.type'>{{alert.msg}}</alert>" +
          "</div>";
      Element elem = compileComponent(html, $compile, $rootScope, injector);

      //print('elem.outerHtml: ' + elem.outerHtml);
      //print('elem.children[0]: ' + elem.children[0].outerHtml);
      //print('shadow inner of 0: ' + elem.children[0].shadowRoot.innerHtml);
      expect(findAlert(elem, 0)).toHaveClass("alert-success");
      
    })));
    
    test("should generate alerts using ng-repeat", async(inject(() {
      $rootScope.alerts = alerts;
      Element elem = compileComponent(HTML, $compile, $rootScope, injector, repeatDigest:2);
      expect(elem.children.length).toEqual(3);
      
      for (Element e in elem.children) {
        expect(e.shadowRoot.querySelector('.alert')).toBeNotNull();
      }
    })));
    
    test("should use correct classes for different alert types", async(inject(() {
      $rootScope.alerts = alerts;
      Element elem = compileComponent(HTML, $compile, $rootScope, injector, repeatDigest:2);
      
      expect(findAlert(elem, 0)).toHaveClass('alert-success');
      expect(findAlert(elem, 1)).toHaveClass('alert-error');

      //defaults
      expect(findAlert(elem, 2)).toHaveClass('alert');
      expect(findAlert(elem, 2)).not.toHaveClass('alert-info');
      expect(findAlert(elem, 2)).not.toHaveClass('alert-block');
    })));
    
    test("should fire callback when closed", async(inject(() {

      int closeIndex = 1;
      $rootScope.alerts = alerts;
      $rootScope.closeCallbackCalls=0;
      $rootScope.onCloseCallback = (int index) {
        $rootScope.closeCallbackCalls++;
        expect(index).toBe(closeIndex);
      };
      
      Element elem = compileComponent(HTML, $compile, $rootScope, injector, repeatDigest:2);
      findCloseButton(elem, closeIndex).click();
      expect($rootScope.closeCallbackCalls).toBe(1);
    })));

    test("should show close buttons", async(inject(() {

      $rootScope.alerts = alerts;
      $rootScope.onCloseCallback = () {};
      
      Element elem = compileComponent(HTML, $compile, $rootScope, injector, repeatDigest:2);

      for (var i = 0, n = alerts.length; i < n; i++) {
        expect(findCloseButton(elem, i)).toBeNotNull();
      }
    })));
    
    test("should not show close buttons if no close callback specified", async(inject(() {

      $rootScope.alert = { 'msg':'foo', 'type':'success'};
      String html = "<div test-div>" + 
          "<alert type='alert.type'>{{alert.msg}}</alert>" +
          "</div>";
      Element elem = compileComponent(html, $compile, $rootScope, injector, repeatDigest:2);
      
      print('shadow inner of 0: ' + elem.children[0].shadowRoot.innerHtml);
      
      for (var i = 0, n = alerts.length; i < n; i++) {
        expect(findCloseButton(elem, i)).toBeNull();
      }
    })));

/*
    it('should not show close buttons if no close callback specified', function () {
      element = $compile('<alert>No close</alert>')(scope);
      scope.$digest();
      expect(findCloseButton(0).css('display')).toBe('none');
    });
*/
    
    /*
    it('it should be possible to add additional classes for alert', function () {
      var element = $compile('<alert class="alert-block" type="\'info\'">Default alert!</alert>')(scope);
      scope.$digest();
      expect(element).toHaveClass('alert-block');
      expect(element).toHaveClass('alert-info');
    });
    */
    
  });
}

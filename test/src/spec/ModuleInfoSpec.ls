package
{
    import system.platform.Path;

    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.lsdoc.models.DefinitionConstruct;
    import pixeldroid.lsdoc.models.ModuleInfo;
    import pixeldroid.lsdoc.models.TypeInfo;


    public static class ModuleInfoSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('ModuleInfo');

            it.should('retrieve types by package membership', types_by_package);
            it.should('retrieve types by construct', types_by_construct);
            it.should('collect all packages in a set of types', get_packages);
            it.should('collect all subpackages under a parent package in a set of types', get_subpackages);
        }


        private static function types_by_package():void
        {
            var r:Vector.<TypeInfo>;
            var t:Vector.<TypeInfo> = testTypes;

            r = ModuleInfo.getTypesByPackage(t, '');
            it.expects(r.length).toEqual(1);

            r = ModuleInfo.getTypesByPackage(t, 'test');
            it.expects(r.length).toEqual(0);

            r = ModuleInfo.getTypesByPackage(t, 'test.pkga');
            it.expects(r.length).toEqual(7);

            r = ModuleInfo.getTypesByPackage(t, 'test.pkgb.suba');
            it.expects(r.length).toEqual(2);
        }

        private static function types_by_construct():void
        {
            var r:Vector.<TypeInfo>;
            var t:Vector.<TypeInfo> = testTypes;

            r = ModuleInfo.getTypesByConstruct(t, DefinitionConstruct.CLASS);
            it.expects(r.length).toEqual(8);

            r = ModuleInfo.getTypesByConstruct(t, DefinitionConstruct.DELEGATE);
            it.expects(r.length).toEqual(5);

            r = ModuleInfo.getTypesByConstruct(t, DefinitionConstruct.ENUM);
            it.expects(r.length).toEqual(2);

            r = ModuleInfo.getTypesByConstruct(t, DefinitionConstruct.INTERFACE);
            it.expects(r.length).toEqual(4);

            r = ModuleInfo.getTypesByConstruct(t, DefinitionConstruct.STRUCT);
            it.expects(r.length).toEqual(3);
        }

        private static function get_packages():void
        {
            var r:Vector.<TypeInfo>;
            var t:Vector.<TypeInfo> = testTypes;

            r = ModuleInfo.getPackages(t);
            it.expects(r.length).toEqual(7);
        }

        private static function get_subpackages():void
        {
            var r:Vector.<TypeInfo>;
            var t:Vector.<TypeInfo> = testTypes;

            r = ModuleInfo.getSubpackages(t, '');
            it.expects(r.length).toEqual(1);

            r = ModuleInfo.getSubpackages(t, 'test');
            it.expects(r.length).toEqual(2);

            r = ModuleInfo.getSubpackages(t, 'test.pkga');
            it.expects(r.length).toEqual(3);
        }


        private static function get testTypes():Vector.<TypeInfo>
        {
            var result:Vector.<TypeInfo> = [];

            result.push(getTestType('ClassTopLevel', '', DefinitionConstruct.CLASS));

            result.push(getTestType('ClassA', 'test.pkga', DefinitionConstruct.CLASS));
            result.push(getTestType('ClassAa', 'test.pkga.suba', DefinitionConstruct.CLASS));
            result.push(getTestType('ClassAb', 'test.pkga.subb', DefinitionConstruct.CLASS));
            result.push(getTestType('ClassAc', 'test.pkga.subc', DefinitionConstruct.CLASS));
            result.push(getTestType('DelegateA1', 'test.pkga', DefinitionConstruct.DELEGATE));
            result.push(getTestType('DelegateA2', 'test.pkga', DefinitionConstruct.DELEGATE));
            result.push(getTestType('EnumA', 'test.pkga', DefinitionConstruct.ENUM));
            result.push(getTestType('InterfaceA', 'test.pkga', DefinitionConstruct.INTERFACE));
            result.push(getTestType('InterfaceAa', 'test.pkga.suba', DefinitionConstruct.INTERFACE));
            result.push(getTestType('StructA1', 'test.pkga', DefinitionConstruct.STRUCT));
            result.push(getTestType('StructA2', 'test.pkga', DefinitionConstruct.STRUCT));

            result.push(getTestType('ClassB', 'test.pkgb', DefinitionConstruct.CLASS));
            result.push(getTestType('ClassBa', 'test.pkgb.suba', DefinitionConstruct.CLASS));
            result.push(getTestType('ClassBb', 'test.pkgb.subb', DefinitionConstruct.CLASS));
            result.push(getTestType('DelegateB1', 'test.pkgb', DefinitionConstruct.DELEGATE));
            result.push(getTestType('DelegateB2', 'test.pkgb', DefinitionConstruct.DELEGATE));
            result.push(getTestType('DelegateB3', 'test.pkgb', DefinitionConstruct.DELEGATE));
            result.push(getTestType('EnumB', 'test.pkgb', DefinitionConstruct.ENUM));
            result.push(getTestType('InterfaceB', 'test.pkgb', DefinitionConstruct.INTERFACE));
            result.push(getTestType('InterfaceBa', 'test.pkgb.suba', DefinitionConstruct.INTERFACE));
            result.push(getTestType('StructB', 'test.pkgb', DefinitionConstruct.STRUCT));

            return result;
        }

        private static function getTestType(name:String, packageString:String, construct:DefinitionConstruct):TypeInfo
        {
            var t:TypeInfo = new TypeInfo();

            t.name = name;
            t.interfaceStrings = ['Ia', 'Ib', 'Ic'];
            t.packageString = packageString;
            t.sourceFile = './src/.//' +packageString.split('.').join('/') +'/' +name +'.ls';
            t.construct = construct.toString();

            return t;
        }
    }
}

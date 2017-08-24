package pixeldroid.lsdoc.processors.tasks.ghpages
{
    import pixeldroid.lsdoc.models.DefinitionConstruct;
    import pixeldroid.lsdoc.models.LibModule;
    import pixeldroid.lsdoc.models.LibType;

    import pixeldroid.json.Json;
    import pixeldroid.json.YamlPrinter;
    import pixeldroid.json.YamlPrinterOptions;
    import pixeldroid.task.SingleTask;
    import pixeldroid.util.Log;


    public class GeneratePackagePage extends SingleTask
    {
        private static const logName:String = GeneratePackagePage.getTypeName();
        private static var _yamlOptions:YamlPrinterOptions;

        private static function get yamlOptions():YamlPrinterOptions
        {
            if (!_yamlOptions)
            {
                _yamlOptions = YamlPrinterOptions.compact;
                _yamlOptions.printDocumentEnd = true; // required for Jekyll to recognize as front matter
            }

            return _yamlOptions;
        }

        private static function getPackagePage(pkg:String, moduleInfo:LibModule):Vector.<String>
        {
            var result:Vector.<String> = [];
            var types:Vector.<LibType> = moduleInfo.types;
            var submodules:Vector.<String>;
            var memberTypes:Vector.<Dictionary.<String,Object>>;

            var page:Dictionary.<String,Object> = {
                'layout' : 'package',
                'module' : pkg,
            };

            if ((submodules = LibModule.getSubpackages(types, pkg)).length > 0)
                page['submodules'] = submodules;

            if ((memberTypes = getMembersByConstruct(types, pkg, DefinitionConstruct.CLASS)).length > 0)
                page['classes'] = memberTypes;

            if ((memberTypes = getMembersByConstruct(types, pkg, DefinitionConstruct.DELEGATE)).length > 0)
                page['delegates'] = memberTypes;

            if ((memberTypes = getMembersByConstruct(types, pkg, DefinitionConstruct.ENUM)).length > 0)
                page['enums'] = memberTypes;

            if ((memberTypes = getMembersByConstruct(types, pkg, DefinitionConstruct.INTERFACE)).length > 0)
                page['interfaces'] = memberTypes;

            if ((memberTypes = getMembersByConstruct(types, pkg, DefinitionConstruct.STRUCT)).length > 0)
                page['structs'] = memberTypes;

            var pageJson:Json = Json.fromObject(page);

            yamlOptions.printDocumentEnd = true; // required for Jekyll to recognize as front matter

            result.push(YamlPrinter.print(pageJson, yamlOptions));

            return result;
        }

        private static function getMembersByConstruct(types:Vector.<LibType>, pkg:String, construct:DefinitionConstruct):Vector.<Dictionary.<String,Object>>
        {
            var filteredTypes:Vector.<LibType>;
            var memberInfo:Dictionary.<String,Object>;
            var result:Vector.<Dictionary.<String,Object>> = [];

            filteredTypes = LibModule.getTypesByConstruct(types, construct);
            filteredTypes = LibModule.getTypesByPackage(filteredTypes, pkg);

            for each(var t:LibType in filteredTypes)
            {
                memberInfo = {
                    'name' : t.name,
                    'declaration' : t.sourceFile
                };

                if (t.docString.length > 0)
                    memberInfo['description'] = t.docString;

                result.push(memberInfo);
            }

            return result;
        }


        private var packageName:String;
        private var moduleInfo:LibModule;

        public var lines:Vector.<String>;


        public function GeneratePackagePage(packageName:String, moduleInfo:LibModule)
        {
            this.packageName = packageName;
            this.moduleInfo = moduleInfo;
        }


        override protected function performTask():void
        {
            Log.debug(logName, function():String{ return 'performTask() for ' +packageName; });

            lines = GeneratePackagePage.getPackagePage(packageName, moduleInfo);

            moduleInfo = null;

            complete();
        }

    }
}

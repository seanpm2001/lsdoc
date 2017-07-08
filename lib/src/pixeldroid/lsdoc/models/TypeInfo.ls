package pixeldroid.lsdoc.models
{
    import system.JSON;

    // import pixeldroid.lsdoc.models.FieldInfo;
    // import pixeldroid.lsdoc.models.MetaInfo;
    // import pixeldroid.lsdoc.models.MethodInfo;
    // import pixeldroid.lsdoc.models.PropertyInfo;


    public class TypeInfo
    {
        public var baseTypeString:String;
        public const classAttributes:Vector.<String> = [];
        //public var constructor:MethodInfo;
        public var delegateReturnTypeString:String;
        public const delegateTypeStrings:Vector.<String> = [];
        public var docString:String;
        //public var fields:Vector.<FieldInfo>;
        public const interfaceStrings:Vector.<String> = [];
        //public const metaInfo:Vector.<MetaInfo> = [];
        //public var methods:Vector.<MethodInfo>;
        public var name:String;
        public var packageString:String;
        //public var properties:Vector.<PropertyInfo>;
        public var sourceFile:String;
        public var construct:String;

        public function TypeInfo():void
        {
        }

        public function toString():String { return packageString +'.' +name; }

        public static function fromJSON(j:JSON):TypeInfo
        {
            var t:TypeInfo = new TypeInfo();

            t.name = j.getString('name');
            t.baseTypeString = j.getString('baseType');
            t.classAttributes = stringVector(j.getArray('classattributes'));
            t.delegateReturnTypeString = j.getString('delegateReturnType');
            t.delegateTypeStrings = stringVector(j.getArray('delegateTypes'));
            t.docString = j.getString('docString');
            t.interfaceStrings = stringVector(j.getArray('interfaces'));
            t.packageString = j.getString('package');
            t.sourceFile = j.getString('source');
            t.construct = j.getString('type');

            return t;
        }

        private static function stringVector(j:JSON):Vector.<String>
        {
            var v:Vector.<String> = [];
            var n:Number = j.getArrayCount();
            for (var i:Number = 0; i < n; i++) v.push(j.getArrayString(i));

            return v;
        }

    }
}

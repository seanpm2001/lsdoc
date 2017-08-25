package pixeldroid.lsdoc.models
{
    import system.JSON;

    import pixeldroid.lsdoc.LibUtils;
    import pixeldroid.lsdoc.models.DefinitionConstruct;
    import pixeldroid.lsdoc.models.TypeField;
    import pixeldroid.lsdoc.models.TypeMethod;
    // import pixeldroid.lsdoc.models.ElementMetaData;
    import pixeldroid.lsdoc.models.TypeProperty;


    /**
    Encapsulates the data of a loomlib `type` declaration.

    @see DefinitionConstruct
    */
    public class LibType
    {
        public var baseTypeString:String;
        public const attributes:Vector.<String> = [];
        public var construct:String;
        public var constructor:TypeMethod;
        public var delegateReturnTypeString:String;
        public const delegateTypeStrings:Vector.<String> = [];
        public var docString:String;
        public var fields:Vector.<TypeField> = [];
        public const interfaceStrings:Vector.<String> = [];
        //public var metaInfo:ElementMetaData;
        public var methods:Vector.<TypeMethod> = [];
        public var name:String;
        public var packageString:String;
        public var properties:Vector.<TypeProperty> = [];
        public var sourceFile:String;

        public function toString():String { return packageString +'.' +name; }

        public static function fromJSON(j:JSON):LibType
        {
            var t:LibType = new LibType();

            t.name = j.getString('name');
            t.construct = j.getString('type');

            t.baseTypeString = j.getString('baseType');
            LibUtils.extractStringVector(j.getArray('classattributes'), t.attributes);
            t.delegateReturnTypeString = j.getString('delegateReturnType');
            LibUtils.extractStringVector(j.getArray('delegateTypes'), t.delegateTypeStrings);
            t.docString = j.getString('docString');
            LibUtils.extractStringVector(j.getArray('interfaces'), t.interfaceStrings);
            t.packageString = j.getString('package');
            t.sourceFile = LibUtils.cleanSourcePath(j.getString('source'), t.packageString);

            var construct:DefinitionConstruct = DefinitionConstruct.fromString(t.construct);
            switch(construct)
            {
                case DefinitionConstruct.CLASS:
                case DefinitionConstruct.STRUCT:
                    t.constructor = TypeMethod.fromJSON(j.getObject('constructor'));
                    t.constructor.returnTypeString = t.packageString +'.' +t.name;
                    break;
            }

            var jj:JSON;
            var n:Number;
            var i:Number;

            // TODO: LibUtils.extractTypeVector(j.getArray('methods'), TypeMethod.fromJSON, t.methods);
            jj = j.getArray('methods');
            n = jj.getArrayCount();
            for (i = 0; i < n; i++)
               t.methods.push(TypeMethod.fromJSON(jj.getArrayObject(i)));

            // TODO: LibUtils.extractTypeVector(j.getArray('fields'), TypeField.fromJSON, t.fields);
            jj = j.getArray('fields');
            n = jj.getArrayCount();
            for (i = 0; i < n; i++)
               t.fields.push(TypeField.fromJSON(jj.getArrayObject(i)));

            // TODO: LibUtils.extractTypeVector(j.getArray('properties'), TypeField.fromJSON, t.properties);
            jj = j.getArray('properties');
            n = jj.getArrayCount();
            for (i = 0; i < n; i++)
               t.properties.push(TypeProperty.fromJSON(jj.getArrayObject(i)));

            return t;
        }

    }
}

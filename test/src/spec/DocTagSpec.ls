package
{
    import pixeldroid.bdd.Spec;
    import pixeldroid.bdd.Thing;

    import pixeldroid.lsdoc.models.DocTag;


    public static class DocTagSpec
    {
        private static var it:Thing;

        public static function specify(specifier:Spec):void
        {
            it = specifier.describe('DocTag');

            it.should('extract a tag from a line', extract_from_line);
            it.should('extract a list of tags from a field', extract_from_field);
            it.should('extract tags from a list that match a given name', extract_matching_tags_from_list);
            it.should('extract tags from a list that don\'t match a given name', extract_nonmatching_tags_from_list);
            it.should('not lose backslashes when processing', not_lose_characters);
        }


        private static function extract_from_line():void
        {
            var no_at:String = 'tag value';
            var no_space:String = '@tagvalue';
            var tag1:String = '@tag value';
            var tag2:String = '  \t  @tag valueA valueB  \t';
            var result:DocTag;

            result = DocTag.fromRawLine(tag1);
            it.asserts(result).isNotNull().or('"' +tag1 +'" did not parse into a tag');
            it.expects(result.name).toEqual('tag');
            it.expects(result.value).toEqual('value');

            result = DocTag.fromRawLine(tag2);
            it.asserts(result).isNotNull().or('"' +tag2 +'" did not parse into a tag');
            it.expects(result.name).toEqual('tag');
            it.expects(result.value).toEqual('valueA valueB');

            result = DocTag.fromRawLine(no_space);
            it.expects(result).toBeNull();

            result = DocTag.fromRawLine(no_at);
            it.expects(result).toBeNull();
        }

        private static function not_lose_characters():void
        {
            var field:String = File.loadTextFile('fixtures/description_escapes.md').trim();
            var tags:Vector.<DocTag> = [];
            var description:String = DocTag.fromRawField(field, tags);

            it.expects(description.length).toEqual(field.length);
        }

        private static function extract_from_field():void
        {
            var lines:Vector.<String> = [
                '  Description first line.',
                '',
                '  Additional text',
                '',
                '  @tag1 value1',
                '  @tag2 value2a value2b',
                '  @tag3 value3a value3b value3c',
            ];
            var field:String = lines.join('\n');
            var tags:Vector.<DocTag> = [];
            var description:String = DocTag.fromRawField(field, tags);

            it.expects(description.trim()).toEqual('Description first line.\n\n  Additional text');

            it.asserts(tags.length).isEqualTo(3).or('field did not parse into 3 tags:\n' +field);
            it.expects(tags[0].toString()).toEqual('@tag1 value1');
            it.expects(tags[1].toString()).toEqual('@tag2 value2a value2b');
            it.expects(tags[2].toString()).toEqual('@tag3 value3a value3b value3c');
        }

        private static function extract_matching_tags_from_list():void
        {
            var lines:Vector.<String> = [
                '  @tag1 value1a',
                '  @tag2 value2a',
                '  @tag1 value1b',
                '  @tag1 value1c',
                '  @tag3 value3a',
                '  @tag1 value1d',
            ];
            var field:String = lines.join('\n');
            var source:Vector.<DocTag> = [];

            DocTag.fromRawField(field, source);
            it.asserts(source.length).isGreaterThan(0).or('field did not parse into any tags:\n' +field);

            var target:Vector.<DocTag> = [];
            var result:Boolean = DocTag.selectByTagName(source, 'tag1', target);

            it.expects(result).toBeTruthy();
            it.asserts(target.length).isEqualTo(4).or('4 tags were not found named "tag1":\n' +field);
            it.expects(target[0].toString()).toEqual('@tag1 value1a');
            it.expects(target[1].toString()).toEqual('@tag1 value1b');
            it.expects(target[2].toString()).toEqual('@tag1 value1c');
            it.expects(target[3].toString()).toEqual('@tag1 value1d');
        }

        private static function extract_nonmatching_tags_from_list():void
        {
            var lines:Vector.<String> = [
                '  @tag1 value1a',
                '  @tag2 value2a',
                '  @tag1 value1b',
                '  @tag1 value1c',
                '  @tag3 value3a',
                '  @tag1 value1d',
            ];
            var field:String = lines.join('\n');
            var source:Vector.<DocTag> = [];

            DocTag.fromRawField(field, source);
            it.asserts(source.length).isGreaterThan(0).or('field did not parse into any tags:\n' +field);

            var target:Vector.<DocTag> = [];
            var result:Boolean = DocTag.selectByTagName(source, 'tag1', target, true);

            it.expects(result).toBeTruthy();
            it.asserts(target.length).isEqualTo(2).or('2 tags were not found not named "tag1":\n' +field);
            it.expects(target[0].toString()).toEqual('@tag2 value2a');
            it.expects(target[1].toString()).toEqual('@tag3 value3a');
        }

    }
}

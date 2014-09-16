package ;

import massive.munit.Assert;
class StringTest {
    @Test
    public function testSubstring() {
        Assert.areEqual('c', 'abcdef'.substring(2,3));
        Assert.areEqual('a', 'abcdef'.substring(0,1));
        Assert.areEqual('f', 'abcdef'.substring(5,6));

        Assert.areEqual('c', 'abcdef'.substr(2,1));
        Assert.areEqual('a', 'abcdef'.substr(0,1));
        Assert.areEqual('f', 'abcdef'.substr(5,1));

    }

}

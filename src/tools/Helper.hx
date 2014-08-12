package tools;
class Helper {
    public static function getAnchorIdFromUrl(url: String): String {
        var id = StringTools.replace(StringTools.replace(url, 'url(', ''), ')', '');
        if (null == id) return null;
        if (id.indexOf('#') != -1) {
            id = id.substring(id.indexOf('#')+1, id.length-1);
        }
        return id;
    }
}

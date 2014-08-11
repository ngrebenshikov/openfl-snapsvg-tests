package tools;

class Color {
    public var rgba: Int;

    public function new(s: String) {
        if (s.indexOf('transparent') != -1) {
            rgba = 0;
        } else if (s.indexOf('rgb') != -1) {
            var parts = s.split(",");
            var prefix = if (s.indexOf('rgba') != -1) 'rgba(' else 'rgb(';
            rgba = Std.parseInt(StringTools.trim(StringTools.replace(parts[0], prefix, ''))) << 24;
            rgba += Std.parseInt(StringTools.trim(parts[1])) << 16;
            rgba += Std.parseInt(StringTools.trim(parts[2])) << 8;
            if (parts.length < 4) {
                rgba += 0xff;
            } else {
                rgba += Std.int(Std.parseFloat(StringTools.trim(parts[3])) * 255);
            }
        } else if (s.indexOf('#') != -1) {
            rgba = Std.parseInt('0x' + s.substr(1)) << 8;
            rgba += 0xff;
        } else {
            rgba = Std.parseInt('0x' + s) << 8;
            rgba += 0xff;
        }
    }

    public static function areEqual(c1: Color, c2: Color) {
        return Math.abs(c1.rgba - c2.rgba) <= 1;
    }

    public static function areColorsEqual(s1: String, s2: String) {
        return Color.areEqual(new Color(s1), new Color(s2));
    }
}

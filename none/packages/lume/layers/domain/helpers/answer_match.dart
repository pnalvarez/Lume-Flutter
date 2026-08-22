/// Tolerant open-answer matching (accent/plural/stopword aware), ported from
/// the web `answerMatch` helper for trail text games.
abstract final class AnswerMatch {
  const AnswerMatch._();

  static const _stopwords = {
    'a',
    'o',
    'as',
    'os',
    'um',
    'uma',
    'uns',
    'umas',
    'de',
    'do',
    'da',
    'dos',
    'das',
    'em',
    'no',
    'na',
    'nos',
    'nas',
    'e',
    'ou',
    'com',
    'para',
    'por',
    'ao',
    'aos',
    'que',
    'se',
    'sou',
    'era',
    'eu',
    'the',
  };

  static const _accentMap = {
    'á': 'a',
    'à': 'a',
    'ã': 'a',
    'â': 'a',
    'ä': 'a',
    'é': 'e',
    'ê': 'e',
    'è': 'e',
    'ë': 'e',
    'í': 'i',
    'ì': 'i',
    'î': 'i',
    'ï': 'i',
    'ó': 'o',
    'ò': 'o',
    'õ': 'o',
    'ô': 'o',
    'ö': 'o',
    'ú': 'u',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
    'ç': 'c',
    'ñ': 'n',
  };

  static String normalizeText(String s) {
    final lower = s.trim().toLowerCase();
    final stripped = StringBuffer();
    for (final rune in lower.runes) {
      final ch = String.fromCharCode(rune);
      stripped.write(_accentMap[ch] ?? ch);
    }
    return stripped
        .toString()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String stem(String word) {
    var t = word;
    if (t.length > 4) {
      t = t.replaceFirst(RegExp(r'(oes|aes|ais|eis|ns|s)$'), '');
    }
    if (t.length > 5) {
      t = t.replaceFirst(
        RegExp(
          r'(izados?|izadas?|adores?|acao|acoes|mente|ismo|ista|ados?|adas?|idos?|idas?)$',
        ),
        '',
      );
    }
    if (t.length > 4) {
      t = t.replaceFirst(RegExp(r'(os|as|o|a|e)$'), '');
    }
    return t;
  }

  static List<String> tokens(String s) {
    return normalizeText(s)
        .split(' ')
        .where((w) => w.isNotEmpty && !_stopwords.contains(w))
        .map(stem)
        .where((w) => w.isNotEmpty)
        .toList();
  }

  static int levenshtein(String a, String b) {
    final m = a.length;
    final n = b.length;
    if (m == 0) return n;
    if (n == 0) return m;
    var prev = List<int>.generate(n + 1, (i) => i);
    for (var i = 1; i <= m; i++) {
      final cur = List<int>.filled(n + 1, 0)..[0] = i;
      for (var j = 1; j <= n; j++) {
        final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
        cur[j] = [
          prev[j] + 1,
          cur[j - 1] + 1,
          prev[j - 1] + cost,
        ].reduce((x, y) => x < y ? x : y);
      }
      prev = cur;
    }
    return prev[n];
  }

  static bool fuzzyEq(String a, String b) {
    if (a == b) return true;
    if (a.length >= 4 && b.length >= 4 && (a.startsWith(b) || b.startsWith(a))) {
      return true;
    }
    final maxLen = a.length > b.length ? a.length : b.length;
    final tol = maxLen >= 8
        ? 2
        : maxLen >= 5
        ? 1
        : 0;
    return tol > 0 && levenshtein(a, b) <= tol;
  }

  static double similarity(String input, String target) {
    final ni = normalizeText(input);
    final nt = normalizeText(target);
    if (ni.isEmpty || nt.isEmpty) return 0;
    if (ni == nt) return 1;

    final ti = tokens(input);
    final tt = tokens(target);
    if (ti.isEmpty || tt.isEmpty) return fuzzyEq(ni, nt) ? 1 : 0;

    var hits = 0;
    final used = <int>{};
    for (final w in ti) {
      var matched = -1;
      for (var i = 0; i < tt.length; i++) {
        if (!used.contains(i) && fuzzyEq(w, tt[i])) {
          matched = i;
          break;
        }
      }
      if (matched >= 0) {
        used.add(matched);
        hits++;
      }
    }
    final covTarget = hits / tt.length;
    final covInput = hits / ti.length;
    if (covInput == 1 && hits >= 1) {
      return covTarget > 0.8 ? covTarget : 0.8;
    }
    return (covTarget + covInput) / 2;
  }

  static bool isCorrect(
    String input,
    String correct, {
    List<String> aliases = const [],
    double threshold = 0.7,
  }) {
    return [correct, ...aliases]
        .where((t) => t.trim().isNotEmpty)
        .any((t) => similarity(input, t) >= threshold);
  }
}

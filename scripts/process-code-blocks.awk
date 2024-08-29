BEGIN {
  inCode = 0;
  code = "";
  # XXX: Assumes ran from repo root
  highlightCmd = "$PWD" "/scripts/highlight";
}

inCode == 0 && $0 !~ /^<!--cognate/ {
  # Print all other lines
  print $0 >> outfile;
}

$0 == "</code></pre></div>" {
  if (inCode == 1) {
    printf "%s", "<div class=\"code\"><pre><code>" >> outfile;
    print code | (highlightCmd " >> " outfile);
    close(highlightCmd " >> " outfile);
    print "</code></pre></div>" >> outfile;

    inCode = 0;
    code = "";
  }
}

inCode == 1 {
  code = code $0 "\n";
}

/^<!--cognate/ {
  inCode = 1;
}

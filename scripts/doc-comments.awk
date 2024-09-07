BEGIN {
  filename = "";
  docStart[0] = "";
  docEnd[0] = "";
  def[0] = "";
  funcname = "";
  lines[0] = "";
}

/^[^ ]+.cog$/ {
  filename = $0;
  i = 0;
  while ((getline line < filename) > 0) {
    lines[i] = line;
    i++;
  }
  close(filename);

  title = filename;
  sub(/\.cog$/, "", title);
  title = toupper(substr(title, 0, 1)) substr(title, 2);
  print "+++"
  print "title = \"" title "\"";
  print "+++";
  print "";
  print "# " title;
  print "";
}

function show_doc(start, end) {
  firstFence = 1;
  for (i = start[0] + 1; i < end[0]; i++) {
    if (lines[i] == "```") {
      if (firstFence == 1) {
        print "```cognate";
        firstFence = 0;
      } else {
        print lines[i];
        firstFence = 1;
      }
    } else {
      print lines[i];
    }
  }
}

function show_def(start, end) {
  for (i = start; i <= end; i++) {
    print lines[i];
  }
}

/^  pattern/ {
  if (funcname != "") {
    printf "## %s\n\n", funcname;
    show_doc(docStart, docEnd);
    print "";
    print "<details><summary><a href=\"" linkURL filename "#L" (def[1] + 1) "-L" (def[3] + 1) "\">Source</a>" "</summary>";
    print "";
    print "```cognate";
    show_def(def[1], def[3]);
    print "```";
    print "";
    print "</details>"
    print "";
  }
}

/^    capture: doc/ {
  match($0, /start: \(([0-9]+), ([0-9]+)\), end: \(([0-9]+), ([0-9]+)\)/, range);
  docStart[0] = range[1];
  docStart[1] = range[2];
  docEnd[0] = range[3];
  docEnd[1] = range[4];
}

/^    capture: 2 - function/ {
  match($0, /text: `(.+)`/, parts);
  funcname = parts[1];
}

/^    capture:.*definition/ {
  match($0, /start: \(([0-9]+), ([0-9]+)\), end: \(([0-9]+), ([0-9]+)\)/, def);
}

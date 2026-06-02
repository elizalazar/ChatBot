String enterString(String str, int strlen)
{
  String str1=str;
  if (key==BACKSPACE)
  {
    if (str.length()>0)
      str1 = str.substring(0, str.length()-1);
  } else if (str.length()<strlen && key>=32 && key<=122)
    str1 = str + key;
  return str1;
}

void showString(String txt, String label, boolean active,
  int fsz, int x, int y, int bsz)
{
  textFont(Ofont);
  fill(#53984E);
  noStroke();
  rect(x, y, bsz+106, fsz+20, 15);
  textSize(fsz/2);
  fill(#054D0D);
  text(label + txt, x + 20, y+fsz);
}

void title()
{
  textFont(Tfont);
  textSize(100);
  fill(0);
  text("Cow Talk: 24 Hour Cattle Chat", 102, 92);
  image(send, 821, 919, 62, 52);
  image(avatar, 31, 758, 155, 154);
}

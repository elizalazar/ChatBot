/*
 Chatbot
 By Eliza Lazar
 
 You can enter a string & get a reply
 Through responses, we are creating interest & personality
 - formal, sarcastic, witty, silly, offended, etc
 1. exact match - "how are you" --> response
 2. word match - "what", "how" --> response
 3. *AP* phrase match - "i like..." --> response containing ...
 4. random match - punctuation at the end ? !
 & error response --> change the subject, ask them a question
 ^ in order of priority
 Avatar - pictoral representation, colours, & fonts
 */

//must haves: conversation (at least 5 lines of each: 5 responses from each),
//a line to type into, pictoral representation of chatbot, give personality
//can align text left or right, assign talkers

/*can use these to cast to int
 int(lines[start]); parseInt(lines[start]); */

String [] conv = new String [18]; //min = 18;
String msg = ""; //typed in
StringDict exactMatch = new StringDict ();
StringDict wordMatch = new StringDict ();
StringDict phraseMatch = new StringDict (); //AP
StringDict randomMatch = new StringDict ();
PImage avatar, send;
PFont Cfont, Ofont, Tfont;
int alarm=-1;
int typeSpd=5;

void setup()
{
  size(900, 1000);
  Tfont=loadFont("Playbill-48.vlw");
  Ofont=loadFont("SegoePrint-48.vlw");
  send = loadImage("cowbell.png");
  avatar = loadImage("cow3.png");
  String [] lns = loadStrings("chatbot.ini");
  int start=0;
  start = readDict(exactMatch, lns, start);
  start = readDict(wordMatch, lns, start);
  start = readDict(phraseMatch, lns, start);
  start = readDict(randomMatch, lns, start);
  initConv();
}

void draw()
{
  background(#88BCDE);
  showString(msg, "", true, 46, 19, 911, 760);
  for (int i=0; i<conv.length; i++)
  {
    textFont(Ofont);
    textSize(20);
    text(conv[i], 203, 885 - i*44);
  }
  title();
}

void keyTyped()
{
  msg = enterString(msg, 50);
  if (key==ENTER)
  {
    reply(msg);
    alarm=msg.length()*typeSpd;
  }
}

/*
  1. roll up the conversation
 2. get a reply - from exact --> word --> phrase --> random
 3. add msg and reply to the conversation
 4. learn
 5. clear msg
 */
void reply(String str)
{
  String ans = getExact(str);
  if (ans==null)
    ans = getPhrase(str);
  if (ans==null)
    ans = getWord(str);
  if (ans==null)
    ans = getRandom(str);
  for (int i=conv.length-1; i>1; i--)
    conv[i]=conv[i-2];
  conv[1]=str;
  conv[0]=ans;
  learn(conv[2], conv[1]);
  msg="";
}

void learn(String prompt, String ans)
{
  String [] words = splitTokens(prompt, " !\"#$%&\'()*+,-.//:;<>?@[]^\\_~");
  String str = "", ostr;
  for (int i=0; i<words.length; i++)
  {
    str += (i==words.length-1)?words[i]:words[i]+" ";
  }
  ostr = exactMatch.get(str.toLowerCase());
  if (ostr!=null)
  {
    ostr += "|"+ans;
    exactMatch.set(str.toLowerCase(), ostr);
  } else ostr = wordMatch.get(str.toLowerCase());
  for (int i=0; i<words.length; i++)
  {
    str = words[i];
  }
  if (ostr!=null)
  {
    ostr += "|"+ans;
    exactMatch.set(str.toLowerCase(), ostr);
  }
}

String getExact(String msg)
{
  String [] words = splitTokens(msg, " !\"#$%&\'()*+,-.//:;<>?@[]^\\_~");
  String str = "", ostr;
  for (int i=0; i<words.length; i++)
  {
    str += (i==words.length-1)?words[i]:words[i]+" ";
  }
  ostr = exactMatch.get(str.toLowerCase());
  if (ostr!=null)
  {
    String [] replies = split(ostr, "|");
    return replies [(int)random(replies.length)];
  }
  return null;
}

String getPhrase(String msg)
{
  /*
  String [] words = splitTokens(msg, " !\"#$%&\'()*+,-.//:;<>?@[]^\\_~");
   String str = "", ostr;
   for (int i=0; i<words.length; i++)
   {
   str += (i==words.length-1)?words[i]:words[i]+" ";
   }
   ostr = phraseMatch.get(str.toLowerCase());
   if (ostr!=null)
   {
   String [] replies = split(ostr, "|");
   return replies [(int)random(replies.length)];
   }*/
  return null;
}

String getWord(String msg)
{

  String [] words = splitTokens(msg, " \"#$%&\'()*+,-//:;<>@[]^\\_~");
  String str = "", ostr;
  for (int i=0; i<words.length; i++)
  {
    str = words[i];
    ostr = wordMatch.get(str.toLowerCase());
    if (ostr!=null)
    {
      String [] replies = split(ostr, "|");
      return replies [(int)random(replies.length)];
    }
  }
  return null;
}

String getRandom(String msg)
{
  String [] words = splitTokens(msg, " \"#$%&\'()*+,-//:;<>@[]^\\_~");
  String str = "", ostr;
  for (int i=0; i<words.length; i++)
  {
    str = words[i];
    ostr = randomMatch.get(str.toLowerCase());
    if (ostr!=null)
    {
      String [] replies = split(ostr, "|");
      return replies [(int)random(replies.length)];
    }
  }
  ostr=randomMatch.get("error");
  if (ostr!=null)
  {
    String [] replies = split(ostr, "|");
    return replies [(int)random(replies.length)];
  }
  return null;
}

/*
empty conversation
 */
void initConv()
{
  for (int i=0; i<conv.length; i++)
    conv[i] = "";
}

int readDict(StringDict dict, String[] lines, int start)
{
  int num = parseInt(lines[start]);
  for (int i=start+1; i<start+num+1; i++)
  {
    String [] part= split(lines[i], ":");
    dict.set(part[0], part[1]);
  }
  return start+num+1;
}

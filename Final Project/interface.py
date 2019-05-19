from pyswip import Prolog
import re


prolog = Prolog()
prolog.consult("semqa.pl")
print("Knowledge base loaded")
setr1 = "every (.+?) is an? (.+?)\."
setr2 = "any (.+?) is an example of an? (.+?)\."
setr3 = "an? (.+?) is an? (.+?)\."
setrq = "is an? (.+?) an? (.+?)\?"

setrs = "(.+?) is an? (.+?)\."
setrsq = "is (.+?) an? (.+?)\?"

setrsl = "the (.+?) is an? (.+?)\."
setrslq = "is the (.+?) an? (.+?)\?"

equiv = "(.+?) is (.+?)\."
equivl = "(.+?) is the (.+?)\."

ownr = "every (.+?) owns an? (.+?)\."
ownrq = "does an? (.+?) own an? (.+?)\?"

ownrgu = "(.+?) owns an? (.+?)\."
ownrguq = "does (.+?) own an? (.+?)\?"
ownrsgq = "does an? (.+?) own the (.+?)\?"

partr1 = "an? (.+?) is part of an? (.+?)\."
partr2 = "an? (.+?) is part of every (.+?)\."
partrq = "is an? (.+?) part of an? (.+?)\?"

partrgu = "an? (.+?) is part of (.+?)\."
partrguq = "is an? (.+?) part of (.+?)\?"
partrgs = "an? (.+?) is part of the (.+?)\."
partrss = "the (.+?) is part of the (.+?)\."
partrsgq  = "is the (.+?) part of an? (.+?)\?"

partrn1 = "there (is|are) (\d+?) (.+?)s? on (each|a) (.+?)\."
partrn2 = "an? (.+?) has (\d+?) (.+?)s\."
partrnu = "there (is|are) (\d+?) (.+?)s? on (.+?)\."
partrnuq = "how many (.+?)s does (.+?) have\?"

jright = "the (.+?) is just to the right of the (.+?)\."
jleft = "the (.+?) is just to the left of the (.+?)\."
right = "the (.+?) is to the right of the (.+?)\."
left = "the (.+?) is to the left of the (.+?)\."
jrightssq = "is the (.+?) just to the right of the (.+?)\?"
jleftssq = "is the (.+?) just to the left of the (.+?)\?"
rightssq = "is the (.+?) to the right of the (.+?)\?"
leftssq = "is the (.+?) to the left of the (.+?)\?"
wheres = "where is the (.+?)\?"
locates = "what is the position of the (.+?)\?"
whereg = "where is an? (.+?)\?"

# Sample dialog regexes for Peter Clark paper
conductrn = "(.+)? is a (.+?) conductor of (.+?)\."
best_conductorq = "which among the following is the best conductor of (.+?):(.+?)\?"
prop = "a property of an? (.+?) is that it is (.+?)\."
proplist = "list the properties of an? (.+?)\."
i = ""
while i!="exit":
	i = input("Your dialog:")
	i = i.replace('-','_')
	print("Computer:",end=" ")
	if re.match(setr1,i):
		m = re.match(setr1,i)
		q=list(prolog.query("setr("+m.group(1)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	#Peter clark dialogs starting
	elif re.match(conductrn,i):
		m = re.match(conductrn,i)
		q=list(prolog.query("conductrn("+m.group(1)+","+m.group(3)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(prop,i):
		m = re.match(prop,i)
		q=list(prolog.query("property("+m.group(1)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(best_conductorq,i):
		m = re.match(best_conductorq,i)
		q=list(prolog.query("best_conductorq(["+m.group(2)+"],"+m.group(1)+",[good,average,bad],X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(proplist,i):
		m = re.match(proplist,i)
		q=list(prolog.query("property_listq("+m.group(1)+",_,X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	# Peter Clark dialogs end
	elif re.match(setr2,i):
		m = re.match(setr2,i)
		q=list(prolog.query("setr("+m.group(1)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(setr3,i):
		m = re.match(setr3,i)
		q=list(prolog.query("setr("+m.group(1)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(partrsgq,i):
		m = re.match(partrsgq,i)
		q=list(prolog.query("partrsgq("+m.group(1)+","+m.group(2)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(setrslq,i):
		m = re.match(setrslq,i)
		q=list(prolog.query("setrslq("+m.group(1)+","+m.group(2)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(setrsl,i):
		m = re.match(setrsl,i)
		q=list(prolog.query("setrsl("+m.group(1)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(equivl,i):
		m = re.match(equivl,i)
		q=list(prolog.query("equivl("+m.group(1)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(ownr,i):
		m = re.match(ownr,i)
		q=list(prolog.query("ownr("+m.group(2)+","+m.group(1)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(ownrq,i):
		m = re.match(ownrq,i)
		q=list(prolog.query("ownrq("+m.group(2)+","+m.group(1)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(ownrgu,i):
		m = re.match(ownrgu,i)
		q=list(prolog.query("ownrgu("+m.group(2)+","+m.group(1)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(ownrguq,i):
		m = re.match(ownrguq,i)
		q=list(prolog.query("ownrguq("+m.group(2)+","+m.group(1)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(ownrsgq,i):
		m = re.match(ownrsgq,i)
		q=list(prolog.query("ownrsgq("+m.group(2)+","+m.group(1)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(partr1,i):
		m = re.match(partr1,i)
		q=list(prolog.query("partr("+m.group(1)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(partr2,i):
		m = re.match(partr2,i)
		q=list(prolog.query("partr("+m.group(1)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(partrq,i):
		m = re.match(partrq,i)
		q=list(prolog.query("partrq("+m.group(1)+","+m.group(2)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(setrq,i):
		m = re.match(setrq,i)
		q=list(prolog.query("setrq("+m.group(1)+","+m.group(2)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(setrsq,i):
		m = re.match(setrsq,i)
		q=list(prolog.query("setrsq("+m.group(1)+","+m.group(2)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(partrgs,i):
		m = re.match(partrgs,i)
		q=list(prolog.query("partrgs("+m.group(1)+","+m.group(2)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(partrgu,i):
		m = re.match(partrgu,i)
		q=list(prolog.query("partrgu("+m.group(1)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(partrguq,i):
		m = re.match(partrguq,i)
		q=list(prolog.query("partrguq("+m.group(1)+","+m.group(2)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(partrss,i):
		m = re.match(partrss,i)
		q=list(prolog.query("partrss("+m.group(1)+","+m.group(2)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(partrn1,i):
		m = re.match(partrn1,i)
		q=list(prolog.query("partrn("+m.group(3)+","+m.group(5)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(partrn2,i):
		m = re.match(partrn2,i)
		q=list(prolog.query("partrn("+m.group(3)+","+m.group(1)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(partrnu,i):
		m = re.match(partrnu,i)
		q=list(prolog.query("partrnu("+m.group(2)+","+m.group(3)+","+m.group(4)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(partrnuq,i):
		m = re.match(partrnuq,i)
		q=list(prolog.query("partrnuq("+m.group(1)+","+m.group(2)+",X,Y).",1))
		if q[0]['Y']=="yes":
			try: print(q[0]['X'].decode("utf-8"))
			except: print(("The answer is "+ str(q[0]['X'])))
		else:
			try: print(q[0]['Y'].decode("utf-8"))
			except: print(q[0]['Y'])
	elif re.match(jright,i):
		m = re.match(jright,i)
		q=list(prolog.query("jright("+m.group(1)+","+m.group(2)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(jleft,i):
		m = re.match(jleft,i)
		q=list(prolog.query("jright("+m.group(2)+","+m.group(1)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(right,i):
		m = re.match(right,i)
		q=list(prolog.query("right("+m.group(1)+","+m.group(2)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(left,i):
		m = re.match(left,i)
		q=list(prolog.query("right("+m.group(2)+","+m.group(1)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(jrightssq,i):
		m = re.match(jrightssq,i)
		q=list(prolog.query("jrightssq("+m.group(1)+","+m.group(2)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(jleftssq,i):
		m = re.match(jleftssq,i)
		q=list(prolog.query("jrightssq("+m.group(2)+","+m.group(1)+",X)."))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(rightssq,i):
		m = re.match(rightssq,i)
		q=list(prolog.query("rightssq("+m.group(1)+","+m.group(2)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(leftssq,i):
		m = re.match(leftssq,i)
		q=list(prolog.query("rightssq("+m.group(2)+","+m.group(1)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(wheres,i):
		m = re.match(wheres,i)
		q=list(prolog.query("wheres("+m.group(1)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(locates,i):
		m = re.match(locates,i)
		q=list(prolog.query("locates("+m.group(1)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(whereg,i):
		m = re.match(whereg,i)
		q=list(prolog.query("whereg("+m.group(1)+",X).",1))
		try: print(q[0]['X'].decode("utf-8"))
		except: print(q[0]['X'])
	elif re.match(setrs,i):
		m = re.match(setrs,i)
		q=list(prolog.query("setrs("+m.group(1)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif re.match(equiv,i):
		m = re.match(equiv,i)
		q=list(prolog.query("equiv("+m.group(1)+","+m.group(2)+").",1))
		if bool(q):
			print("I understand")
		else:
			print("Unable to respond,please try again")
	elif i=="exit":
		print("Exiting")
	else:
		print("Could not parse dialog, please re-enter")
		
		
		
		
		
		
		
		
		
		
		
		
		

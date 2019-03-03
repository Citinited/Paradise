/obj/item/dragonball
	name = "dragon ball"
	desc = "Legends say that the one who brings all seven of these together shall have any one wish granted."
	icon = 'icons/obj/dragonball.dmi'
	icon_state = "dragonball"
	var/inert = FALSE

/obj/item/dragonball/attack_self(mob/user)
	var/list/the_balls = list()
	for(var/obj/item/dragonball/D in subtypesof(/obj/item/dragonball))
		if(locate(D in range(1, src)) && !D.inert)
			the_balls.Add(D)
			continue
		to_chat(user, "<span class='warning'>[src] does nothing, despite your best wishes.</span")
		return
	to_chat(user, "ALL BALLS HERE!")
	for(var/obj/item/dragonball/DB in the_balls)
		DB.make_inert()
	summon_shenron(get_turf(src), user)
	qdel(the_balls)

/obj/item/dragonball/proc/make_inert()
	desc = "It's just an inert stone ball now."
	inert = TRUE

/obj/item/dragonball/proc/summon_shenron(turf/T, mob/user)
	var/obj/effect/shenron/S = new /obj/effect/shenron(T)
	S.atom_say("<strong>I AM [uppertext(S.name)].</strong>")
	S.atom_say("<strong>YOU ARE DISTURBING ME FROM MY SLUMBER. WHAT IS YOUR WISH?</strong>")
	var/message //What to show to the user
	var/I = input(user, "Choose your wish!", "FUCK YEAH") as null|anything in list("Booze", "Magic", "Money", "More wishes", "Power", "Sex")
	switch(I)
		if("Booze")
			message = "YOU WISH TO BE INTOXICATED? VERY WELL!"
		if("Magic")
			message = "MAGIC"
		if("Money")
			message = "A POPULAR REQUEST, AND ONE I CAN EASILY GRANT YOU."
		if("More wishes")
			message = "NICE TRY, BUT I AM A LITTLE TOO OLD TO FALL FOR THAT ONE. GOOD DAY."
		if("Power")
			message = "EVERYONE WISHES FOR MORE POWER. I HOPE YOU WIELD IT WELL."
		if("Sex")
			message = "A CARNAL DESIRE, BUT ONE I SHALL GRANT FOR YOU."
		if(null)
			message = "YOU WISHED FOR NOTHING. A PLEASANT DAY TO YOU."
		else
			message = "UNFORTUNATELY, THAT IS BEYOND MY POWERS."
	S.atom_say("<strong>[message]</strong>")
	S.visible_message("<span class='notice'>With its work done, [S.name] vanishes in a roar and a cloud of smoke.</span>")
	qdel(S)


/obj/item/dragonball/one
	icon_state = "dragonball_1"

/obj/item/dragonball/two
	icon_state = "dragonball_2"

/obj/item/dragonball/three
	icon_state = "dragonball_3"

/obj/item/dragonball/four
	icon_state = "dragonball_4"

/obj/item/dragonball/five
	icon_state = "dragonball_5"

/obj/item/dragonball/six
	icon_state = "dragonball_6"

/obj/item/dragonball/seven
	icon_state = "dragonball_7"


/obj/effect/dragonball_spawner/New()
	..()
	for(var/obj/item/dragonball/D in subtypesof(/obj/item/dragonball))
		D = new(src)
		D.x = rand(20, 236)
		D.y = rand(20, 236)
		D.z = 1

/obj/effect/shenron
	name = "Shenron, the Eternal Dragon"
	desc = "The legends are true!"
	atom_say_verb = "<strong>booms</strong>"
	icon = 'icons/effects/shenron.dmi'
	icon_state = "shenron"

/obj/effect/shenron/New()
	..()
	pixel_x = -64

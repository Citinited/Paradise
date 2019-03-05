GLOBAL_LIST_INIT(dragonballs, list())

/obj/item/dragonball
	name = "dragon ball"
	desc = "Legends say that the one who brings all seven of these together shall have any one wish granted."
	icon = 'icons/obj/dragonball.dmi'
	icon_state = "dragonball"
	var/inert = FALSE
	var/dragonball_in_use = FALSE

/obj/item/dragonball/New()
	..()
	GLOB.dragonballs.Add(src)
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

/obj/item/dragonball/Destroy()
	GLOB.dragonballs.Remove(src)
	..()

/obj/item/dragonball/attack_self(mob/user)
	if(dragonball_in_use)
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return
	var/list/the_balls = list()
	for(var/path in subtypesof(/obj/item/dragonball))
		if(path == type || locate(path) in range(1, get_turf(src)))
			var/obj/item/dragonball/D = path
			the_balls.Add(D)
			continue
		to_chat(user, "<span class='warning'>[src] does nothing, despite your best wishes.</span")
		return
	for(var/obj/item/dragonball/DB in the_balls)
		to_chat(user, "[DB] and [DB.type]")
		DB.dragonball_in_use = TRUE
	var/big_bad_dragon = summon_shenron(get_turf(src), user)
	for(var/obj/item/dragonball/DB in the_balls)
		big_bad_dragon ? DB.make_inert() : DB.dragonball_in_use == FALSE
	qdel(the_balls)

/obj/item/dragonball/update_icon()
	icon_state = inert ? "dragonball_inert" : initial(icon_state)

/obj/item/dragonball/proc/make_inert()
	desc = "It's just an inert stone ball now."
	inert = TRUE
	GLOB.dragonballs.Remove(src)
	update_icon()

/obj/item/dragonball/proc/summon_shenron(turf/T, mob/living/carbon/human/user)
	var/turf/user_turf = get_turf(user)
	var/obj/effect/shenron/S = new /obj/effect/shenron(T)
	S.atom_say("<strong>I AM [uppertext(S.name)].</strong>")
	S.atom_say("<strong>YOU ARE DISTURBING ME FROM MY SLUMBER. WHAT IS YOUR WISH?</strong>")
	var/message //What to show to the user
	var/I = input(user, "Choose your wish!", "FUCK YEAH") as null|anything in list("Booze", "Magic", "Money", "More wishes", "Power", "Sex")
	switch(I)
		if("Booze")
			message = "YOU WISH TO BE INTOXICATED? VERY WELL!"
			for(var/path in subtypesof(/obj/item/reagent_containers/food/drinks/bottle))
				var/obj/item/reagent_containers/food/drinks/bottle/B = new(user_turf)
				B.pixel_x = rand(-16, 16)
				B.pixel_y = rand(-16, 16)
		if("Magic")
			message = "THE LURE OF THE ARCANE, AN UNDERSTANDABLE WISH.THIS POWER SHALL BE YOURS."
			var/list/spells = shuffle(subtypesof(/obj/item/spellbook/oneuse))
			for(var/i in 1 to 3)
				var/path = pick_n_take(spells)
				var/obj/item/spellbook/oneuse/B = new path(user_turf)
				user.equip_or_collect(B, slot_l_hand)
		if("Money")
			message = "A POPULAR REQUEST, AND ONE I CAN EASILY GRANT YOU."
			var/obj/item/stack/spacecash/c1000000/C = new(user_turf)
			user.equip_or_collect(C, slot_l_hand)
		if("More wishes")
			message = "WISHING FOR MORE WISHES IS SOMETHING I CANNOT GRANT. GOOD DAY."
		if("Power")
			message = "EVERYONE WISHES FOR MORE POWER. I HOPE YOU WIELD IT WELL."
		if("Sex")
			message = "A CARNAL DESIRE, BUT ONE I SHALL GRANT FOR YOU."
			new /mob/living/simple_animal/hostile/alien/maid(user_turf)
			new /mob/living/simple_animal/hostile/alien/maid(user_turf)
		if(null)
			message = "YOU WISHED FOR NOTHING. A PLEASANT DAY TO YOU."
		else
			message = "UNFORTUNATELY, THAT IS BEYOND MY POWERS."
	S.atom_say("<strong>[message]</strong>")
	S.visible_message("<span class='notice'>With its work done, [S.name] vanishes in a roar and a cloud of smoke.</span>")
	qdel(S)
	return TRUE


/obj/item/dragonball/one
	name = "one-star dragon ball"
	icon_state = "dragonball_1"

/obj/item/dragonball/two
	name = "two-star dragon ball"
	icon_state = "dragonball_2"

/obj/item/dragonball/three
	name = "three-star dragon ball"
	icon_state = "dragonball_3"

/obj/item/dragonball/four
	name = "four-star dragon ball"
	icon_state = "dragonball_4"

/obj/item/dragonball/five
	name = "five-star dragon ball"
	icon_state = "dragonball_5"

/obj/item/dragonball/six
	name = "six-star dragon ball"
	icon_state = "dragonball_6"

/obj/item/dragonball/seven
	name = "seven-star dragon ball"
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

/obj/item/dragon_radar
	name = "dragon radar"
	desc = "A handheld device that makes tracking the dragon balls easier."
	icon = 'icons/obj/dragonball.dmi'
	icon_state = "radar"
	var/cooldown_duration = 30 SECONDS
	var/last_used
	var/tracking

/obj/item/dragon_radar/New()
	..()
	new /datum/action/item_action/track_balls(src)

/obj/item/dragon_radar/attack_self(mob/user)
	if(!tracking)
		to_chat(user, "<span class='warning'>Calibrate [src] first!</span>")
		return
	if(last_used + cooldown_duration > world.time)
		to_chat(user, "<span class='warning'>[src] needs time to recharge.</span>")
		return
	last_used = world.time
	var/turf/our_turf = get_turf(src)
	var/turf/target_turf
	target_turf = get_turf(tracking)
	if(!atoms_share_level(our_turf, target_turf))
		atom_say("Target located too far away.")
	atom_say("Target: [tracking], located [dir2text(get_dir(our_turf, target_turf))], around [get_dist(our_turf, target_turf)] metres away.")

/obj/item/dragon_radar/proc/track(mob/user)
	if(!GLOB.dragonballs.len)
		to_chat(user, "<span class='warning'>[src] doesn't respond.</span>")
		return
	var/I = input(user, "Which dragon ball would you like to track?", "Select a target!") as null|anything in GLOB.dragonballs
	tracking = I
	to_chat(user, "<span class='notice'>You recalibrate [src].</span>")

/datum/action/item_action/track_balls
	name = "Recalibrate dragon radar"

/datum/action/item_action/track_balls/Trigger(attack_self = FALSE)
	..()
	var/obj/item/dragon_radar/DR = target
	DR.track(usr)

/*In this file:
-Balloon animals
-Latex balloons
-Water balloons
*/

/obj/item/balloon
	name = "balloon"
	desc = "It's a balloon."
	icon = 'icons/obj/balloons.dmi'
	icon_state = "uninflated"

/obj/item/balloon/skinny
	name = "long skinny balloon"
	desc = "It's a long thin piece of rubber. You could probably inflate it."
	var/inflated = FALSE

/obj/item/balloon/skinny/New()
	color = pick(random_color_list)
	..()

/obj/item/balloon/skinny/update_icon()
	if(inflated)
		desc = "It's a long thin balloon. You could make fun shapes if you had a few of them."
		icon_state = "inflated"
	else
		icon_state = initial(icon_state)
		desc = initial(desc)
	..()

/obj/item/balloon/skinny/attack_self(mob/user)
	if(!inflated)
		user.visible_message("<span class='notice'>[user] blows into [src] to inflate it.</span>", "<span class='notice'>You blow into [src] to inflate it.</span>", "<span class='danger'>You hear someone blow into something.</span>")
		inflated = TRUE
		update_icon()
	..()
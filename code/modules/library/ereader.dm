#define MODE_LIBRARY	1
#define MODE_READ_BOOK	2


obj/item/ereader
	name = "electronic book"
	icon = 'icons/obj/library.dmi'
	icon_state = "book"
	desc = "An electronic device that connects to the library database and allows you to read any book stored on it. Handy!"
	w_class = WEIGHT_CLASS_NORMAL
	burn_state = FIRE_PROOF
	var/book_data = "Nothing here..."//Content of the book
	var/book_author = "A. Nonymous"//Author of said book
	var/book_title = "default book"//Title of the book
	var/reader_mode = MODE_LIBRARY

/obj/item/ereader/attack_self(mob/user)
	ui_interact(user)

/obj/item/ereader/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = inventory_state)
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ereader.tmpl", "[name]", 400, 650, state = state)
		ui.open()
		ui.set_auto_update(1)

/obj/item/ereader/ui_data(mob/user, ui_key = "main", datum/topic_state/state = inventory_state)
	var/data[0]
	data["reader_mode"] = reader_mode
	data["book_data"] = book_data
	data["book_author"] = book_author
	data["book_title"] = book_title
	data["book_list"] = library_catalog.cached_books
	return data

/obj/item/ereader/AltClick(mob/user)
	to_chat(world, "checking books")
	for(var/i in library_catalog)
		to_chat(world, "book here")
	for(var/i in library_catalog/library_catalog)
		to_chat(world, "book 2 here")

/obj/item/ereader/Topic(href, href_list, nowindow, state)
	..()
	if(href_list["reader_mode"])
		reader_mode = href_list["reader_mode"]
	SSnanoui.update_uis(src)
#undef MODE_LIBRARY
#undef MODE_READ_BOOK
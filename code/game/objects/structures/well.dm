//Fluff structures serve no purpose and exist only for enriching the environment. They can be destroyed with a wrench.

/obj/structure/well
	name = "well"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "well"
	anchored = TRUE
	density = TRUE
	opacity = 0
	climb_time = 40
	climbable = TRUE
	layer = 2.91
	damage_deflection = 30

/obj/structure/well/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/bucket))
		var/obj/item/reagent_containers/glass/bucket/W = I
		if(W.reagents.holder_full())
			to_chat(user, span_warning("[W] is full."))
			return
		if(do_after(user, 60, target = src))
			var/list/waterl = list(/datum/reagent/water = 200)
			W.reagents.add_reagent_list(waterl)
			to_chat(user, "<span class='notice'>I fill [W] from [src].</span>")
			playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 80, FALSE)
			return
	else ..()

/obj/structure/well/fountain
	name = "water fountain"
	desc = ""
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "fountain"
	layer = BELOW_MOB_LAYER
	layer = -0.1

/obj/structure/well/fountain/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.is_mouth_covered())
				return
		playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		user.visible_message(span_info("[user] starts to drink from [src]."))
		if(do_after(L, 25, target = src))
			var/list/waterl = list(/datum/reagent/water = 2)
			var/datum/reagents/reagents = new()
			reagents.add_reagent_list(waterl)
			reagents.trans_to(L, reagents.total_volume, transfered_by = user, method = INGEST)
			playsound(user,pick('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg'), 100, TRUE)
			onbite(user)
		return
	..()

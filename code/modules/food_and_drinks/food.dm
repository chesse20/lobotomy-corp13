////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/// Note: When adding food items with dummy parents, make sure to add
/// the parent to the exclusion list in code/__HELPERS/unsorted.dm's
/// get_random_food proc.
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/food
	possible_transfer_amounts = list()
	volume = 50	//Sets the default container amount for all food items.
	reagent_flags = INJECTABLE
	resistance_flags = FLAMMABLE
	var/foodtype = NONE
	var/last_check_time
	var/in_container = FALSE //currently just stops "was bitten X times!" messages on canned food

/obj/item/reagent_containers/food/Initialize(mapload)
	. = ..()
	if(!mapload)
		pixel_x = rand(-5, 5)
		pixel_y = rand(-5, 5)

/obj/item/reagent_containers/food/proc/checkLiked(fraction, mob/M)
	if(last_check_time + 50 < world.time)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!HAS_TRAIT(H, TRAIT_AGEUSIA))
				if(foodtype & H.dna.species.toxic_food)
					to_chat(H,"<span class='warning'>What the hell was that thing?!</span>")
					H.adjust_disgust(25 + 30 * fraction)
				else if(foodtype & H.dna.species.disliked_food)
					to_chat(H,"<span class='notice'>That didn't taste very good...</span>")
					H.adjust_disgust(11 + 15 * fraction)
				else if(foodtype & H.dna.species.liked_food)
					to_chat(H,"<span class='notice'>I love this taste!</span>")
					H.adjust_disgust(-5 + -2.5 * fraction)
			else
				if(foodtype & H.dna.species.toxic_food)
					to_chat(H, "<span class='warning'>You don't feel so good...</span>")
					H.adjust_disgust(25 + 30 * fraction)
			last_check_time = world.time

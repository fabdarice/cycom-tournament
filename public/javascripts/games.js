function cancelEdit(link)
{
    form = link.parentNode;

    new Effect.BlindUp(form, { duration: 0.2, afterFinish: function(){form.remove()}});
}

function cancelTreeEdit(link)
{
    form = link.parentNode;

    form.parentNode.childNodes[2].toggle();
    form.remove();
}

function updateScore(round)
{
    form = $("round_edit_" + round);
    form.childNodes[1].replace("<img src=\"/images/loading.gif\" alt=\"\" />");
    new Ajax.Request("/rounds/" + round, {asynchronous:true, evalScripts:true, parameters:Form.serialize(form)});
}

function updateTreeScore(round)
{
    form = $("round_edit_" + round);
    form.childNodes[6].replace("<img src=\"/images/loading.gif\" alt=\"\"");
    new Ajax.Request("/rounds/" + round, {asynchronous:true, evalScripts:true, parameters:Form.serialize(form)});
}

function editTreeScore(score)
{
    s = score.innerHTML.split('/');

    first_score = s[0].replace(/\s/g, "");
    second_score = s[1].replace(/\s/g, "");

    round_id = score.id.substring(6);

    form = "<form class=\"tree_round_edit\" action=\"/rounds/" + round_id + "\" method=\"post\""
	+ " id=\"round_edit_" + round_id + "\" onsubmit=\"updateTreeScore(" + round_id + "); return false;\">";
    form += "<input name=\"_method\" type=\"hidden\" value=\"put\" />";
    form += "<a onClick=\"cancelTreeEdit(this)\">X</a>";
    form += "<input id=\"round_first_score\" name=\"round[first_score]\" type=\"text\" value=\"" + first_score + "\" />";
    form += "<input id=\"round_second_score\" name=\"round[second_score]\" type=\"text\" value=\"" + second_score + "\" />";
    form += "<input id=\"round_live\" name=\"round_live\" type=\"checkbox\" />";
    form += "<label for=\"round_live\">live</label>";
    form += "<input id=\"round_submit\" name=\"commit\" type=\"submit\" value=\"Ok\" />";
    form += "</form>";

    score.parentNode.insert({ before: form });
    score.parentNode.toggle();

    Field.activate(score.parentNode.parentNode.childNodes[1].childNodes[2]);

    event.stop();
}

function editScore(score)
{	
	first_participant = score.parentNode.childNodes[0].childNodes[1].innerHTML;
	second_participant = score.parentNode.childNodes[0].childNodes[3].innerHTML;

	first_score = score.childNodes[1].childNodes[1].innerHTML;
	second_score = score.childNodes[1].childNodes[3].innerHTML;

	round_id = score.childNodes[1].id.substring(6);

	form = "<form style=\"display: none;\" class=\"round_edit\" action=\"/rounds/" + round_id + "\" method=\"post\""
			+ " id=\"round_edit_" + round_id + "\" onsubmit=\"updateScore(" + round_id + "); return false;\">";
	form += "<input name=\"_method\" type=\"hidden\" value=\"put\" />";
	form += "<a onClick=\"cancelEdit(this)\">[X]</a> ";

	form += "<label for=\"round_first_score\">" + first_participant + "</label>";
	form += "<input id=\"round_first_score\" name=\"round[first_score]\" type=\"text\" value=\"" + first_score + "\" />";

	form += " - ";

	form += "<input id=\"round_second_score\" name=\"round[second_score]\" type=\"text\" value=\"" + second_score + "\" />";
	form += "<label for=\"round_second_score\">" + second_participant + "</label>";

	form += "<select id=\"round_state\" name=\"round[state]\">";
	form += "<option value=\"a jouer\">a jouer</option>";
	form += "<option value=\"en cours\">en cours</option>";
	form += "<option value=\"Terminé\" selected=\"selected\">terminé</option>";
	form += "<option value=\"match nul\">match nul</option>";
	form += "<option value=\"win_first\">win_first</option>";
	form += "<option value=\"win_second\">win_second</option></select>"

	form += " <input id=\"round_submit\" name=\"commit\" type=\"submit\" value=\"OK\" />";

	form += "</form>"

	if (score.className == "left")
		newForm = score.parentNode.next().insert({
			after: form
		});
	else
		newForm = score.parentNode.insert({
			after: form
		});

	new Effect.BlindDown(newForm.next() , { duration: 0.2,
			     afterFinish: function(){
				 Field.activate(newForm.next().childNodes[4]);
		}});

	event.stop();
}

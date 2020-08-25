var timeoutFn = undefined;
$(document).ready(function () {
	window.addEventListener('message', function (event) {

		if (event.data.hud == true) {
			$("#hud").css("display", "block");
		}

		if (event.data.hud == false) {
			$("#hud").css("display", "none");
		}

		if (event.data.car == true) {
			var mph = event.data.seatbelt == true ? "<s>KMH</s>" : "<b>KMH</b>"
			$("#carDisplay").css("display", "block");
			$("#carDisplay").html("<b>F</b>" + event.data.fuel + "  " + mph + event.data.speed);
			$(".img").css("margin-bottom", "-0.2%");
		} else {
			$("#carDisplay").css("display", "none");
			$(".img").css("margin-bottom", "-2.0%");
		}

		$(".infosBack").html("<b>" + event.data.day + "</b>, <b>" + event.data.month + "</b>  :  " + event.data.street);

		if (event.data.talking == true) {
			$(".voiceBack i").css("color", "rgba(255,255,255,0.9)");
		} else {
			$(".voiceBack i").css("color", "rgba(70,70,70,0.8)");
		}

		if (event.data.voice == 1) {
			$(".voiceDisplay1").css("display", "block");
			$(".voiceBack i").css("filter", "drop-shadow(0 0 7px rgba(40, 200, 40, 0.9))");
			$("#voice").text("S");
			$(".voiceDisplay2").css("display", "none");
			$(".voiceDisplay3").css("display", "none");
		}

		if (event.data.voice == 2) {
			$(".voiceDisplay1").css("display", "none");
			$(".voiceDisplay2").css("display", "block");
			$(".voiceBack i").css("filter", "drop-shadow(0 0 12px rgba(0, 0, 150, 0.9))");
			$("#voice").text("N");
			$(".voiceDisplay3").css("display", "none");
		}

		if (event.data.voice == 3) {
			$(".voiceDisplay1").css("display", "none");
			$(".voiceDisplay2").css("display", "none");
			$(".voiceDisplay3").css("display", "block");
			$(".voiceBack i").css("filter", "drop-shadow(0 0 18px rgba(200, 50, 50, 0.9))");
			$("#voice").text("G");
		}



		$(".screen").css("display", event.data.status ? "none" : "block");
		$(".hudDisplayText").html(event.data.hour + "<br>" + event.data.minute);
		$("#health").text(event.data.health + "%");
		$("#armor").text(event.data.armor + "%");
		$("#hunger").text(100 - event.data.hunger + "%");
		$("#thirst").text(100 - event.data.thirst + "%");
	});
});
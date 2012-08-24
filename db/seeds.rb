# encoding: utf-8

user = User.new
user.username = "admin"
user.password = User.encrypt "password"
user.first_name = "Admin"
user.last_name = ""
user.user_level = "MASTER"
user.save!



config = Preference.new
config.name = "clock_style"
config.value = "swissRail"
config.save!

config = Preference.new
config.name = "home_report_1"
config.value = "client_events"
config.save!

config = Preference.new
config.name = "home_report_1_period"
config.value = "7"
config.save!

config = Preference.new
config.name = "home_report_2"
config.value = "horse_events"
config.save!

config = Preference.new
config.name = "home_report_2_period"
config.value = "7"
config.save!

config = Preference.new
config.name = "price_list"
config.value = '<div id="price_list_content">
	<h2>Price List</h2>
	<table>
		<tr>
			<th>
				Adult
			</th>
			<th>
				1hr
			</th>
			<th>
				45mins
			</th>
			<th>
				30mins
			</th>
		</tr>
		<tr>
			<td>
				Walkout
			</td>
			<td>
			
			</td>
			<td>
				£39.00
			</td>
			<td>
				£35.00
			</td>
		</tr>
		<tr>
			<td>
				Group Hack
			</td>
			<td>
				£49.00
			</td>
			<td>
			
			</td>
			<td>
			
			</td>
		</tr>
		<tr>
			<td>
				Group Lesson
			</td>
			<td>
				£49.00
			</td>
			<td>
			
			</td>
			<td>
			
			</td>
		</tr>
		<tr>
			<td>
				Private Lesson
			</td>
			<td>
				£79.00
			</td>
			<td>
				£63.00
			</td>
			<td>
				£51.00
			</td>
		</tr>
		<tr>
			<td>
				Semi-Pri (2 ppl)
			</td>
			<td>
				£130.00
			</td>
			<td>
				£110.00
			</td>
			<td>
				£86.00
			</td>
		</tr>
	</table>
	<table>
		<tr>
			<th colspan="2">
				Career Students
			</th>
		</tr>
		<tr>
			<td>
				Stage 1,2,3 Group Lesson
			</td>
			<td>
				£51.00
			</td>
		</tr>
	</table>
	<table>
		<tr>
			<th>
				BHS Exam Prep.
			</th>
			<th>
				Stg 1-3
			</th>
			<th>
				Stg 4
			</th>
			<th>
				PTT
			</th>
		</tr>
		<tr>
			<th>
				courses / day
			</th>
			<td>
				£102.00
			</td>
			<td>
				£120.00
			</td>
			<td>
				£104.00
			</td>
		</tr>
	</table>
	<table>
		<tr>
			<th>
				Under 18
			</th>
			<th>
				1hr
			</th>
			<th>
				45mins
			</th>
			<th>
				30mins
			</th>
		</tr>
		<tr>
			<td>
				Walkout
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
			<td>
				£29.00
			</td>
		</tr>
		<tr>
			<td>
				Group Hack
			</td>
			<td>
				£38.00
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				Group Lesson
			</td>
			<td>
				£38.00
			</td>
			<td>
				£35.00
			</td>
			<td>
				£31.00
			</td>
		</tr>
		<tr>
			<td>
				Private
			</td>
			<td>
				£60.00
			</td>
			<td>
				£55.00
			</td>
			<td>
				£41.00
			</td>
		</tr>
		<tr>
			<td>
				Semi-Pri (2 ppl)
			</td>
			<td>
				£110.00
			</td>
			<td>
				£100.00
			</td>
			<td>
				£67.00
			</td>
		</tr>
	</table>
	<table>
		<tr>
			<th colspan="2">
				Stable Management Lectures
			</th>
		</tr>
		<tr>
			<td>
				Group
			</td>
			<td>
				£38.00
			</td>
		</tr>
		<tr>
			<td>
				Private
			</td>
			<td>
				£52.00
			</td>
		</tr>
		<tr>
			<td>
				Under 18 Group
			</td>
			<td>
				£32.00
			</td>
		</tr>
	</table>
	<table>
		<tr>
			<th colspan="2">
				Intro Courses - 30mins Private
			</th>
		</tr>
		<tr>
			<td>
				Adult Lessons x10<br/>
				(includes BHS \'Learn to Ride)
			</td>
			<td>
				£378.00
			</td>
		</tr>
		<tr>
			<td>
				Under 18 Lessons x10
			</td>
			<td>
				£304.00
			</td>
		</tr>
	</table>
	<table>
		<tr>
			<th colspan="2">
				Working Livery
			</th>
		</tr>
		<tr>
			<td>
				Under 14-2 HH
			</td>
			<td>
				£9.45 per day
			</td>
		</tr>
		<tr>
			<td>
				Over 14-2 HH
			</td>
			<td>
				£11.02 per day
			</td>
		</tr>
	</table>
	<table>
		<tr>
			<th colspan="3">
				Discounted Voucher Scheme
			</th>
		</tr>
		<tr>
			<td colspan="3">
				4 vouchers: 10% discount - 1 lesson per week (22 days total)
			</td>
		</tr>
		<tr>
			<td>
				4x1hr G/L
			</td>
			<td>
				Child: £136.80
			</td>
			<td>
				Adult: £176.40
			</td>
		</tr>
		<tr>
			<td>
				4x1/2hr P/L
			</td>
			<td>
				Child: £147.60
			</td>
			<td>
				Adult: £183.60
			</td>
		</tr>
		<tr>
			<td colspan="3">
				8 vouchers: 15% discount - 2 lessons per week (22 days total)
			</td>
		</tr>
		<tr>
			<td>
				8x1hr G/L
			</td>
			<td>
				Child: £258.40
			</td>
			<td>
				Adult: £333.20
			</td>
		</tr>
		<tr>
			<td>
				8x1/2hr P/L
			</td>
			<td>
				Child: £278.80
			</td>
			<td>
				Adult: £346.80
			</td>
		</tr>
		<tr>
			<td colspan="3">
				4 Group Lesson Vouchers
			</td>
		</tr>
		<tr>
			<td>
				4x3/4hr Group
			</td>
			<td>
				Child: £126.00
			</td>
			<td>
				Adult: £226.80
			</td>
		</tr>
	</table>
</div>'
config.save!



config = SiteSetting.new
config.name = "application_status_check"
config.value = "0"
config.external = false
config.save!

config = SiteSetting.new
config.name = "block_auto_assign_prompt"
config.value = Date.today.to_time.advance(:days => -1).to_date
config.external = false
config.save!

config = SiteSetting.new
config.name = "event_chain_id"
config.value = "0"
config.external = false
config.save!

config = SiteSetting.new
config.name = "status_check_interval"
config.value = "1"
config.external = true
config.save!

config = SiteSetting.new
config.name = "business_name"
config.value = "Rycroft School of Equitation"
config.external = true
config.save!

config = SiteSetting.new
config.name = "business_address"
config.value = "New Mill Lane, Eversley, Hampshire, RG27 0RA"
config.external = true
config.save!

config = SiteSetting.new
config.name = "business_telephone"
config.value = "01189 732 761"
config.external = true
config.save!

config = SiteSetting.new
config.name = "business_email"
config.value = "rycroft.riding@btopenworld.com"
config.external = true
config.save!

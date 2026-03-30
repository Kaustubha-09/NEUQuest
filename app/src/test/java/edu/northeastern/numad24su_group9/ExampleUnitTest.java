package edu.northeastern.numad24su_group9;

import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import edu.northeastern.numad24su_group9.model.Event;
import edu.northeastern.numad24su_group9.model.Trip;

import static org.junit.Assert.*;

public class ExampleUnitTest {

    // -------------------------------------------------------------------------
    // Event.isWithinDateRange
    // -------------------------------------------------------------------------

    @Test
    public void isWithinDateRange_eventOnStartDate_returnsTrue() {
        Event event = new Event();
        assertTrue(event.isWithinDateRange("01/06/2024", "01/06/2024", "10/06/2024"));
    }

    @Test
    public void isWithinDateRange_eventOnEndDate_returnsTrue() {
        Event event = new Event();
        assertTrue(event.isWithinDateRange("10/06/2024", "01/06/2024", "10/06/2024"));
    }

    @Test
    public void isWithinDateRange_eventInMiddle_returnsTrue() {
        Event event = new Event();
        assertTrue(event.isWithinDateRange("05/06/2024", "01/06/2024", "10/06/2024"));
    }

    @Test
    public void isWithinDateRange_eventBeforeStart_returnsFalse() {
        Event event = new Event();
        assertFalse(event.isWithinDateRange("31/05/2024", "01/06/2024", "10/06/2024"));
    }

    @Test
    public void isWithinDateRange_eventAfterEnd_returnsFalse() {
        Event event = new Event();
        assertFalse(event.isWithinDateRange("11/06/2024", "01/06/2024", "10/06/2024"));
    }

    @Test
    public void isWithinDateRange_singleDayTripMatchingEvent_returnsTrue() {
        Event event = new Event();
        assertTrue(event.isWithinDateRange("15/07/2024", "15/07/2024", "15/07/2024"));
    }

    @Test
    public void isWithinDateRange_singleDayTripNotMatchingEvent_returnsFalse() {
        Event event = new Event();
        assertFalse(event.isWithinDateRange("16/07/2024", "15/07/2024", "15/07/2024"));
    }

    @Test
    public void isWithinDateRange_crossYearBoundary_returnsTrue() {
        Event event = new Event();
        assertTrue(event.isWithinDateRange("01/01/2025", "31/12/2024", "02/01/2025"));
    }

    // -------------------------------------------------------------------------
    // Event.compareTo (chronological ordering)
    // -------------------------------------------------------------------------

    @Test
    public void compareTo_earlierEventIsLess() {
        Event earlier = makeEvent("01/06/2024", "09:00");
        Event later   = makeEvent("01/06/2024", "18:00");
        assertTrue(earlier.compareTo(later) < 0);
    }

    @Test
    public void compareTo_laterEventIsGreater() {
        Event earlier = makeEvent("01/06/2024", "09:00");
        Event later   = makeEvent("02/06/2024", "09:00");
        assertTrue(later.compareTo(earlier) > 0);
    }

    @Test
    public void compareTo_sameDateTime_returnsZero() {
        Event a = makeEvent("15/08/2024", "12:30");
        Event b = makeEvent("15/08/2024", "12:30");
        assertEquals(0, a.compareTo(b));
    }

    @Test
    public void sort_eventsReturnInChronologicalOrder() {
        Event e1 = makeEvent("10/07/2024", "08:00");
        Event e2 = makeEvent("05/07/2024", "20:00");
        Event e3 = makeEvent("05/07/2024", "10:00");

        List<Event> events = new ArrayList<>(Arrays.asList(e1, e2, e3));
        Collections.sort(events);

        assertEquals(e3, events.get(0));
        assertEquals(e2, events.get(1));
        assertEquals(e1, events.get(2));
    }

    // -------------------------------------------------------------------------
    // RightNowActivity.extractTitles (Gemini response parsing)
    // -------------------------------------------------------------------------

    @Test
    public void extractTitles_findsAllBoldTitles() {
        String input = "Here are some events:\n**Museum Night:** great art\n**Food Fest:** try local food";
        List<String> titles = RightNowActivity.extractTitles(input);
        assertEquals(2, titles.size());
        assertEquals("Museum Night", titles.get(0));
        assertEquals("Food Fest", titles.get(1));
    }

    @Test
    public void extractTitles_noMatches_returnsEmptyList() {
        String input = "No bold titles here.";
        List<String> titles = RightNowActivity.extractTitles(input);
        assertTrue(titles.isEmpty());
    }

    @Test
    public void extractTitles_emptyString_returnsEmptyList() {
        List<String> titles = RightNowActivity.extractTitles("");
        assertTrue(titles.isEmpty());
    }

    @Test
    public void extractTitles_boldWithoutColon_notMatched() {
        // Pattern requires **title:** format; **title** alone should not match.
        String input = "This is **just bold** text without a colon.";
        List<String> titles = RightNowActivity.extractTitles(input);
        assertTrue(titles.isEmpty());
    }

    // -------------------------------------------------------------------------
    // SignUpActivity.isValidNeuEmail
    // -------------------------------------------------------------------------

    @Test
    public void isValidNeuEmail_northeasternDomain_returnsTrue() {
        assertTrue(SignUpActivity.isValidNeuEmail("student@northeastern.edu"));
    }

    @Test
    public void isValidNeuEmail_huskyDomain_returnsTrue() {
        assertTrue(SignUpActivity.isValidNeuEmail("student@husky.neu.edu"));
    }

    @Test
    public void isValidNeuEmail_gmailDomain_returnsFalse() {
        assertFalse(SignUpActivity.isValidNeuEmail("student@gmail.com"));
    }

    @Test
    public void isValidNeuEmail_spoofedDomain_returnsFalse() {
        assertFalse(SignUpActivity.isValidNeuEmail("student@northeastern.edu.evil.com"));
    }

    @Test
    public void isValidNeuEmail_emptyString_returnsFalse() {
        assertFalse(SignUpActivity.isValidNeuEmail(""));
    }

    // -------------------------------------------------------------------------
    // Trip.addEventID (null-safety fix)
    // -------------------------------------------------------------------------

    @Test
    public void addEventID_toNullList_doesNotThrow() {
        Trip trip = new Trip();
        // eventIDs starts null; addEventID must not throw NullPointerException.
        trip.addEventID("event-001");
        assertNotNull(trip.getEventIDs());
        assertEquals(1, trip.getEventIDs().size());
        assertEquals("event-001", trip.getEventIDs().get(0));
    }

    @Test
    public void addEventID_toExistingList_appendsEntry() {
        List<String> ids = new ArrayList<>();
        ids.add("event-001");
        Trip trip = new Trip(null, null, null, null, null, ids, null, null, null, null, null, null);
        trip.addEventID("event-002");
        assertEquals(2, trip.getEventIDs().size());
        assertEquals("event-002", trip.getEventIDs().get(1));
    }

    // -------------------------------------------------------------------------
    // AppConstants values sanity checks
    // -------------------------------------------------------------------------

    @Test
    public void budgetSliderMin_isZero() {
        assertEquals(0f, AppConstants.BUDGET_SLIDER_MIN, 0f);
    }

    @Test
    public void budgetSliderMax_greaterThanMin() {
        assertTrue(AppConstants.BUDGET_SLIDER_MAX > AppConstants.BUDGET_SLIDER_MIN);
    }

    @Test
    public void budgetSliderStep_dividesRangeEvenly() {
        float range = AppConstants.BUDGET_SLIDER_MAX - AppConstants.BUDGET_SLIDER_MIN;
        assertEquals(0f, range % AppConstants.BUDGET_SLIDER_STEP, 0.001f);
    }

    @Test
    public void backPressInterval_isPositive() {
        assertTrue(AppConstants.BACK_PRESS_INTERVAL_MS > 0);
    }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    private Event makeEvent(String startDate, String startTime) {
        Event event = new Event();
        event.setStartDate(startDate);
        event.setStartTime(startTime);
        return event;
    }
}

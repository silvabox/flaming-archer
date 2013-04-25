class EventOccurrencesController < ApplicationController
  def show
    @event = Event.find(params[:event_id])
    @occurrence = @event.find_or_new_occurrence_by_start(params_slug_to_time)
    setup_attendances_and_participants
  end

  def update
    @event = Event.find(params[:event_id])
    @occurrence = @event.find_or_new_occurrence_by_start(params_slug_to_time)
    @event.occurrences << @occurrence

    respond_to do |format|
      if @occurrence.update_attributes(params[:event_occurrence])
        format.html { redirect_to [@event, @occurrence], notice: 'Occurrence was successfully updated.' }
        format.json { head :no_content }
      else
        setup_attendances_and_participants
        format.html { render action: "show" }
        format.json { render json: @occurrence.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_participant
    event = Event.find(params[:event_id])
    occurrence = event.find_or_new_occurrence_by_start(params_slug_to_time(:event_occurrence_id))
    event.occurrences << occurrence
    
    attendance = occurrence.attendances.new do |a|
      a.participant = Participant.find(params[:id])
      a.presence = "present"
    end
    attendance.save
    redirect_to [event, occurrence]
  end

  def remove_participant
    event = Event.find(params[:event_id])
    occurrence = event.occurrences.find_by_start(params_slug_to_time(:event_occurrence_id))
    occurrence.participants.delete(Participant.find(params[:id]))
    redirect_to [event, occurrence]
  end

  def open
    @occurrences = Event.all_open_occurrences_up_to
  end

private
  def params_slug_to_time(key = :id)
    EventOccurrence.slug_to_time(params[key])
  end

  def setup_attendances_and_participants
    @participants = @event.grouped_participants

    @attendances = @occurrence.attendances

    @occurrence.participants.each do |participant|
      @participants[:expected].delete participant
      @participants[:other].delete participant
    end
  end

end
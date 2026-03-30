package edu.northeastern.numad24su_group9.recycler;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.google.firebase.database.DatabaseReference;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import edu.northeastern.numad24su_group9.R;
import edu.northeastern.numad24su_group9.firebase.repository.database.EventRepository;
import edu.northeastern.numad24su_group9.firebase.repository.storage.EventImageRepository;
import edu.northeastern.numad24su_group9.model.Event;

public class AdminConsoleAdapter extends ListAdapter<Event, AdminConsoleAdapter.ViewHolder> {

    private final Context context;

    public AdminConsoleAdapter(Context context) {
        super(DIFF_CALLBACK);
        this.context = context;
    }

    /** Submit a new list — DiffUtil computes the diff on a background thread. */
    public void updateData(List<Event> events) {
        submitList(events);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_admin_console_recycler_view, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        Event event = getItem(position);

        if (!Objects.equals(holder.imageView.getTag(), event.getImage())) {
            Glide.with(holder.imageView.getContext())
                    .load(new EventImageRepository().getEventImage(event.getImage()))
                    .placeholder(R.drawable.placeholder_image)
                    .override(300, 300)
                    .into(holder.imageView);
            holder.imageView.setTag(event.getImage());
        }

        holder.titleTextView.setText(event.getTitle());
        holder.descriptionTextView.setText(event.getDescription());

        holder.approveButton.setOnClickListener(v -> {
            int pos = holder.getAdapterPosition();
            if (pos == RecyclerView.NO_ID) return;
            event.setIsReported(false);
            EventRepository eventRepository = new EventRepository();
            DatabaseReference eventRef = eventRepository.getEventRef().child(event.getEventID());
            eventRef.setValue(event);
            removeAt(pos);
        });

        holder.rejectButton.setOnClickListener(v -> {
            int pos = holder.getAdapterPosition();
            if (pos == RecyclerView.NO_ID) return;
            EventRepository eventRepository = new EventRepository();
            DatabaseReference eventRef = eventRepository.getEventRef().child(event.getEventID());
            eventRef.removeValue()
                    .addOnSuccessListener(aVoid -> {
                        removeAt(pos);
                        Toast.makeText(context, "Event deleted successfully", Toast.LENGTH_LONG).show();
                    })
                    .addOnFailureListener(e ->
                            Toast.makeText(context, "Failed to delete event", Toast.LENGTH_LONG).show());
        });
    }

    private void removeAt(int adapterPosition) {
        List<Event> newList = new ArrayList<>(getCurrentList());
        newList.remove(adapterPosition);
        submitList(newList);
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        public final ImageView imageView;
        public final TextView titleTextView;
        public final TextView descriptionTextView;
        public final Button approveButton;
        public final Button rejectButton;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            imageView = itemView.findViewById(R.id.event_image);
            titleTextView = itemView.findViewById(R.id.event_name);
            descriptionTextView = itemView.findViewById(R.id.event_description);
            approveButton = itemView.findViewById(R.id.approve_event_button);
            rejectButton = itemView.findViewById(R.id.remove_event_button);
        }
    }

    private static final DiffUtil.ItemCallback<Event> DIFF_CALLBACK =
            new DiffUtil.ItemCallback<Event>() {
                @Override
                public boolean areItemsTheSame(@NonNull Event oldItem, @NonNull Event newItem) {
                    return Objects.equals(oldItem.getEventID(), newItem.getEventID());
                }

                @Override
                public boolean areContentsTheSame(@NonNull Event oldItem, @NonNull Event newItem) {
                    return Objects.equals(oldItem.getTitle(), newItem.getTitle())
                            && Objects.equals(oldItem.getIsReported(), newItem.getIsReported());
                }
            };
}

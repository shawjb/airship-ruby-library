module Urbanairship
  module Push
    module Payload
      require 'urbanairship/common'

      include Urbanairship::Common

      # Global attributes for the push
      # Seems redundant but it allows global attributes to
      # be added with the same pattern
      def global_attributes(poro)
        poro
      end

      # Notification Object for a Push Payload
      def notification(alert: nil, ios: nil, android: nil, amazon: nil,
                       web: nil, wns: nil, open_platforms: nil,
                       actions: nil, interactive: nil, sms: nil, email: nil, global_attributes: nil)
        payload = compact_helper({
          actions: actions,
          alert: alert,
          amazon: amazon,
          android: android,
          email: email,
          global_attributes: global_attributes,
          interactive: interactive,
          ios: ios,
          sms: sms,
          web: web,
          wns: wns,
        })
        if open_platforms
          open_platforms.each {|platform, overrides|
            payload[platform] = overrides
          }
        end
        fail ArgumentError, 'Notification body is empty' if payload.empty?
        payload
      end

      # iOS specific portion of Push Notification Object
      def ios(alert: nil, badge: nil, sound: nil, content_available: nil,
              extra: nil, expiry: nil, priority: nil, category: nil,
              interactive: nil, mutable_content: nil, media_attachment: nil,
              title: nil, subtitle: nil, collapse_id: nil, thread_id: nil, live_activity: nil)
        compact_helper({
          alert: alert,
          badge: badge,
          sound: sound,
          'content-available' => content_available,
          extra: extra,
          expiry: expiry,
          priority: priority,
          category: category,
          interactive: interactive,
          'mutable-content' => mutable_content,
          media_attachment: media_attachment,
          title: title,
          subtitle: subtitle,
          collapse_id: collapse_id,
          thread_id: thread_id,
          live_activity: live_activity
        })
      end

      # Amazon specific portion of Push Notification Object
      def amazon(alert: nil, consolidation_key: nil, expires_after: nil,
                 extra: nil, title: nil, summary: nil, interactive: nil, style: nil, sound: nil)
        compact_helper({
          alert: alert,
          consolidation_key: consolidation_key,
          expires_after: expires_after,
          extra: extra,
          title: title,
          summary: summary,
          interactive: interactive,
          style: style,
          sound: sound
        })
      end

      # Android specific portion of Push Notification Object
      def android(title: nil, alert: nil, summary: nil, extra: nil,
                  style: nil, icon: nil, icon_color: nil, notification_tag: nil,
                  notification_channel: nil, category: nil, visibility: nil,
                  public_notification: nil, sound: nil, priority: nil, collapse_key: nil,
                  time_to_live: nil, delivery_priority: nil, delay_while_idle: nil,
                  local_only: nil, wearable: nil, background_image: nil, extra_pages: nil,
                  interactive: nil, live_update: nil)
        compact_helper({
          title: title,
          alert: alert,
          summary: summary,
          extra: extra,
          style: style,
          icon: icon,
          icon_color: icon_color,
          notification_tag: notification_tag,
          notification_channel: notification_channel,
          category: category,
          visibility: visibility,
          public_notification: public_notification,
          sound: sound,
          priority: priority,
          collapse_key: collapse_key,
          time_to_live: time_to_live,
          delivery_priority: delivery_priority,
          delay_while_idle: delay_while_idle,
          local_only: local_only,
          wearable: wearable,
          interactive: interactive,
          live_update: live_update
        })
      end

      # Web Notify specific portion of Push Notification Object
      def web(alert: nil, title: nil, extra: nil, require_interaction: nil, icon: nil)
        compact_helper({
          alert: alert,
          title: title,
          extra: extra,
          require_interaction: require_interaction,
          icon: icon
        })
      end

      # WNS specific portion of Push Notification Object
      def wns_payload(alert: nil, toast: nil, tile: nil, badge: nil)
        payload = compact_helper({
          alert: alert,
          toast: toast,
          tile: tile,
          badge: badge
        })
        fail ArgumentError, 'Must specify one message type' if payload.size != 1
        payload
      end

      # Open Platform specific portion of Push Notification Object.
      def open_platform(alert: nil, title: nil, summary: nil,
                        extra: nil, media_attachment: nil, interactive: nil)
        compact_helper({
          alert: alert,
          title: title,
          summary: summary,
          extra: extra,
          media_attachment: media_attachment,
          interactive: interactive
        })
      end

      # Rich Message specific portion of Push Notification Object
      def message(title: required('title'), body: required('body'), content_type: nil, content_encoding: nil,
                  extra: nil, expiry: nil, icons: nil, options: nil)
        compact_helper({
          title: title,
          body: body,
          content_type: content_type,
          content_encoding: content_encoding,
          extra: extra,
          expiry: expiry,
          icons: icons,
          options: options
        })
      end

      # Message from template
      def message_from_template(template_id: required('template_id'))
        {
          template: {
            template_id: template_id
          }
        }
      end

      # In-app message specific portion of Push Notification Object
      def in_app(alert: nil, display_type: nil, display: nil, expiry: nil,
                 actions: nil, interactive: nil, extra: nil)
        compact_helper({
          alert: alert,
          display_type: display_type,
          display: display,
          expiry: expiry,
          actions: actions,
          interactive: interactive,
          extra: extra
        })
      end

      # Interactive Notification portion of Push Notification Object
      def interactive(type: required('type'), button_actions: nil)
        fail ArgumentError, 'type must not be nil' if type.nil?
        compact_helper({ type: type, button_actions: button_actions })
      end

      #SMS specific portion of Push Notification Object
      def sms(alert: nil, expiry: nil)
        compact_helper({
          alert: alert,
          expiry: expiry
          })
      end


      #Email specific portion of Push Notification Object
      def email(bypass_opt_in_level: nil, html_body: nil, message_type: required('message_type'),
                plaintext_body: required('plaintext_body'), reply_to: required('reply_to'),
                sender_address: required('sender_address'), sender_name: required('sender_name'),
                subject: required('subject'))
        fail ArgumentError, 'Message type must not be nil' if message_type.nil?
        fail ArgumentError, 'Plaintext Body must not be nil' if plaintext_body.nil?
        fail ArgumentError, 'Reply To must not be nil' if reply_to.nil?
        fail ArgumentError, 'Sender address must not be nil' if sender_address.nil?
        fail ArgumentError, 'Sender name must not be nil' if sender_name.nil?
        fail ArgumentError, 'Subject must not be nil' if subject.nil?
        compact_helper({
            bypass_opt_in_level: bypass_opt_in_level,
            html_body: html_body,
            message_type: message_type,
            plaintext_body: plaintext_body,
            reply_to: reply_to,
            sender_address: sender_address,
            sender_name: sender_name,
            subject: subject
          })
      end

      def all
        'all'
      end

      # Target specified device types
      def device_types(types)
        types
      end

      # Options for a message
      def options(
        expiry: nil,
        bypass_frequency_limits: nil,
        bypass_holdout_groups: nil,
        no_throttle: nil,
        omit_from_activity_log: nil,
        personalization: nil,
        redact_payload: nil
    )
      compact_helper(
        expiry: expiry,
        bypass_frequency_limits: bypass_frequency_limits,
        bypass_holdout_groups: bypass_holdout_groups,
        no_throttle: no_throttle,
        omit_from_activity_log: omit_from_activity_log,
        personalization: personalization,
        redact_payload: redact_payload
      )
    end

      # Actions for a Push Notification Object
      def actions(add_tag: nil, remove_tag: nil, open_: nil, share: nil,
                  app_defined: nil)
        compact_helper({
          add_tag: add_tag,
          remove_tag: remove_tag,
          open: open_,
          share: share,
          app_defined: app_defined
        })
      end

      # iOS Media Attachment builder
      def media_attachment(url: required('url'), content: nil, options: nil)
        fail ArgumentError, 'url must not be nil' if url.nil?
        compact_helper({
          url: url,
          content: content,
          options: options
        })
      end

      # iOS Content builder. Each argument describes the portions of the
      # notification that should be modified if the media_attachment succeeds.
      def content(title: nil, subtitle: nil, body: nil)
        compact_helper({
          title: title,
          subtitle: subtitle,
          body: body
        })
      end

      # iOS crop builder.
      def crop(x: nil, y: nil, width: nil, height: nil)
        compact_helper({
          x: x,
          y: y,
          width: width,
          height: height
        })
      end

      # Android/Amazon style builder.
      def style(type: required('type'), content: required('content'),
                title: nil, summary: nil)
        fail ArgumentError, 'type must not be nil' if type.nil?

        mapping = {
          big_picture: 'big_picture', big_text: 'big_text', inbox: 'lines'
        }

        compact_helper({
          type: type,
          mapping[type.to_sym] => content,
          title: title,
          summary: summary
        })
      end

      # Android L public notification payload builder.
      def public_notification(title: nil, alert: nil, summary: nil)
        compact_helper({
          title: title,
          alert: alert,
          summary: summary
        })
      end

      # Android wearable payload builder.
      def wearable(background_image: nil, extra_pages: nil, interactive: nil)
        compact_helper({
          background_image: background_image,
          extra_pages: extra_pages,
          interactive: interactive,
        })
      end
      
      # iOS Live Activity
      def live_activity(
        event: required('event'), 
        alert: nil, 
        name: required('name'), 
        priority: nil, 
        content_state: nil, 
        relevance_score: nil, 
        stale_date: nil, 
        dismissal_date: nil, 
        timestamp: nil
      )
        valid_events = ['update', 'end']
        fail ArgumentError, 'Invalid event type' unless valid_events.include?(event)
        fail ArgumentError, 'priority must be 5 or 10' if priority && ![5, 10].include?(priority)
      
        compact_helper({
          event: event,
          alert: alert,
          name: name,
          priority: priority,
          content_state: content_state,
          relevance_score: relevance_score,
          stale_date: stale_date,
          dismissal_date: dismissal_date,
          timestamp: timestamp
        })
      end
      
      # Android Live Update
      def live_update(
        event: required('event'), 
        name: required('name'), 
        content_state: nil, 
        type: nil, 
        dismissal_date: nil, 
        timestamp: nil
      )
        valid_events = ['start', 'update', 'end']
        fail ArgumentError, 'Invalid event type' unless valid_events.include?(event)
      
        compact_helper({
          event: event,
          name: name,
          content_state: content_state,
          type: type,
          dismissal_date: dismissal_date,
          timestamp: timestamp
        })
      end
    end
  end
end

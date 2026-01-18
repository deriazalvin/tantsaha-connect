export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      regions: {
        Row: {
          id: string
          name: string
          name_fr: string
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          name_fr: string
          created_at?: string
        }
        Update: {
          id?: string
          name?: string
          name_fr?: string
          created_at?: string
        }
      }
      profiles: {
        Row: {
          id: string
          full_name: string
          region_id: string | null
          profile_photo_url: string | null
          phone: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          full_name: string
          region_id?: string | null
          profile_photo_url?: string | null
          phone?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          full_name?: string
          region_id?: string | null
          profile_photo_url?: string | null
          phone?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      weather_forecasts: {
        Row: {
          id: string
          region_id: string
          forecast_date: string
          temp_min: number
          temp_max: number
          humidity: number | null
          condition: string
          condition_icon: string
          description_mg: string
          created_at: string
        }
        Insert: {
          id?: string
          region_id: string
          forecast_date: string
          temp_min: number
          temp_max: number
          humidity?: number | null
          condition: string
          condition_icon: string
          description_mg: string
          created_at?: string
        }
        Update: {
          id?: string
          region_id?: string
          forecast_date?: string
          temp_min?: number
          temp_max?: number
          humidity?: number | null
          condition?: string
          condition_icon?: string
          description_mg?: string
          created_at?: string
        }
      }
      weather_alerts: {
        Row: {
          id: string
          region_id: string
          alert_type: string
          severity: 'danger' | 'warning' | 'info'
          title_mg: string
          message_mg: string
          recommendation_mg: string | null
          alert_date: string
          is_active: boolean
          created_at: string
        }
        Insert: {
          id?: string
          region_id: string
          alert_type: string
          severity: 'danger' | 'warning' | 'info'
          title_mg: string
          message_mg: string
          recommendation_mg?: string | null
          alert_date: string
          is_active?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          region_id?: string
          alert_type?: string
          severity?: 'danger' | 'warning' | 'info'
          title_mg?: string
          message_mg?: string
          recommendation_mg?: string | null
          alert_date?: string
          is_active?: boolean
          created_at?: string
        }
      }
      agricultural_advices: {
        Row: {
          id: string
          region_id: string | null
          crop_type: string
          season: string
          title_mg: string
          content_mg: string
          icon: string | null
          created_at: string
        }
        Insert: {
          id?: string
          region_id?: string | null
          crop_type: string
          season: string
          title_mg: string
          content_mg: string
          icon?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          region_id?: string | null
          crop_type?: string
          season?: string
          title_mg?: string
          content_mg?: string
          icon?: string | null
          created_at?: string
        }
      }
      crop_journal: {
        Row: {
          id: string
          user_id: string
          observation_date: string
          observation_type: string
          crop_type: string | null
          notes_mg: string | null
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          observation_date: string
          observation_type: string
          crop_type?: string | null
          notes_mg?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          observation_date?: string
          observation_type?: string
          crop_type?: string | null
          notes_mg?: string | null
          created_at?: string
        }
      }
    }
    Views: {}
    Functions: {}
    Enums: {}
  }
}

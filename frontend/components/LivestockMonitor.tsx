import React, { useState, useEffect, useCallback } from 'react';
import {
  Beef, Search, Plus, X, ChevronDown, ChevronRight, ScanLine, Heart,
  MapPin, Phone, User, Calendar, Weight, Palette, Shield, Activity,
  Building2, FileText, AlertTriangle, Check, Edit3, Trash2, Eye,
  QrCode, Cpu, ArrowLeft, Filter, RefreshCw, TrendingUp, Baby
} from 'lucide-react';
import { Farm, LivestockAnimal, LivestockStatistics, AnimalType, HealthStatus, FarmType } from '../types';
import { ApiService } from '../services/api';

const ANIMAL_ICONS: Record<AnimalType, string> = {
  CATTLE: '\uD83D\uDC02',
  SHEEP: '\uD83D\uDC11',
  GOAT: '\uD83D\uDC10',
  HORSE: '\uD83D\uDC0E',
  CAMEL: '\uD83D\uDC2A',
};

const ANIMAL_LABELS: Record<AnimalType, string> = {
  CATTLE: 'Qoramol',
  SHEEP: "Qo'y",
  GOAT: 'Echki',
  HORSE: 'Ot',
  CAMEL: 'Tuya',
};

const HEALTH_COLORS: Record<HealthStatus, { bg: string; text: string; label: string }> = {
  HEALTHY: { bg: 'bg-emerald-100', text: 'text-emerald-700', label: "Sog'lom" },
  SICK: { bg: 'bg-red-100', text: 'text-red-700', label: 'Kasal' },
  QUARANTINE: { bg: 'bg-orange-100', text: 'text-orange-700', label: 'Karantin' },
  VACCINATED: { bg: 'bg-blue-100', text: 'text-blue-700', label: 'Emlangan' },
  TREATMENT: { bg: 'bg-purple-100', text: 'text-purple-700', label: 'Davolanmoqda' },
};

const FARM_TYPE_LABELS: Record<FarmType, string> = {
  CATTLE: 'Qoramol ferma',
  SHEEP: "Qo'y ferma",
  GOAT: 'Echki ferma',
  HORSE: 'Ot ferma',
  CAMEL: 'Tuya ferma',
  MIXED: 'Aralash ferma',
};

interface LivestockMonitorProps {
  farms: Farm[];
  livestock: LivestockAnimal[];
  stats: LivestockStatistics | null;
  onRefresh: () => void;
  onAddFarm: (farm: Partial<Farm>) => Promise<void>;
  onAddLivestock: (animal: Partial<LivestockAnimal>) => Promise<void>;
  onUpdateLivestock: (id: string, updates: Partial<LivestockAnimal>) => Promise<void>;
  onDeleteLivestock: (id: string) => Promise<void>;
  onDeleteFarm: (id: string) => Promise<void>;
}

type ViewMode = 'overview' | 'farms' | 'livestock' | 'scanner' | 'passport';

const LivestockMonitor: React.FC<LivestockMonitorProps> = ({
  farms, livestock, stats, onRefresh, onAddFarm, onAddLivestock, onUpdateLivestock, onDeleteLivestock, onDeleteFarm
}) => {
  const [view, setView] = useState<ViewMode>('overview');
  const [selectedFarm, setSelectedFarm] = useState<Farm | null>(null);
  const [selectedAnimal, setSelectedAnimal] = useState<LivestockAnimal | null>(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [filterType, setFilterType] = useState<AnimalType | 'ALL'>('ALL');
  const [filterHealth, setFilterHealth] = useState<HealthStatus | 'ALL'>('ALL');
  const [showAddFarmModal, setShowAddFarmModal] = useState(false);
  const [showAddAnimalModal, setShowAddAnimalModal] = useState(false);
  const [scannerInput, setScannerInput] = useState('');
  const [scanResult, setScanResult] = useState<LivestockAnimal | null>(null);
  const [scanError, setScanError] = useState('');
  const [scanLoading, setScanLoading] = useState(false);
  const [loading, setLoading] = useState(false);

  // New Farm form
  const [newFarm, setNewFarm] = useState({
    name: '', ownerName: '', ownerPhone: '', farmType: 'MIXED' as FarmType,
    address: '', mfy: '', areaHectares: 0, lat: 40.38, lng: 71.79
  });

  // New Animal form
  const [newAnimal, setNewAnimal] = useState({
    microchipId: '', animalType: 'CATTLE' as AnimalType, breed: '', name: '',
    gender: 'MALE' as 'MALE' | 'FEMALE', birthDate: '', weightKg: 0, color: '',
    farmId: '', notes: ''
  });

  const filteredLivestock = livestock.filter(a => {
    if (filterType !== 'ALL' && a.animalType !== filterType) return false;
    if (filterHealth !== 'ALL' && a.healthStatus !== filterHealth) return false;
    if (selectedFarm && a.farmId !== selectedFarm.id) return false;
    if (searchQuery) {
      const q = searchQuery.toLowerCase();
      return a.microchipId.toLowerCase().includes(q) ||
        a.name.toLowerCase().includes(q) ||
        a.breed.toLowerCase().includes(q);
    }
    return true;
  });

  const handleScan = async () => {
    if (!scannerInput.trim()) return;
    setScanLoading(true);
    setScanError('');
    setScanResult(null);
    try {
      const result = await ApiService.lookupByMicrochip(scannerInput.trim());
      setScanResult(result);
    } catch (e: any) {
      setScanError('Chorva topilmadi. Microchip ID ni tekshiring.');
    } finally {
      setScanLoading(false);
    }
  };

  const handleAddFarm = async () => {
    if (!newFarm.name || !newFarm.ownerName) return;
    setLoading(true);
    try {
      await onAddFarm({
        name: newFarm.name, ownerName: newFarm.ownerName, ownerPhone: newFarm.ownerPhone,
        farmType: newFarm.farmType, address: newFarm.address, mfy: newFarm.mfy,
        areaHectares: newFarm.areaHectares, location: { lat: newFarm.lat, lng: newFarm.lng },
        isActive: true,
      });
      setShowAddFarmModal(false);
      setNewFarm({ name: '', ownerName: '', ownerPhone: '', farmType: 'MIXED', address: '', mfy: '', areaHectares: 0, lat: 40.38, lng: 71.79 });
    } catch (e) {
      alert("Ferma qo'shishda xatolik yuz berdi");
    } finally {
      setLoading(false);
    }
  };

  const handleAddAnimal = async () => {
    if (!newAnimal.microchipId || !newAnimal.breed || !newAnimal.farmId) return;
    setLoading(true);
    try {
      await onAddLivestock({
        microchipId: newAnimal.microchipId, animalType: newAnimal.animalType,
        breed: newAnimal.breed, name: newAnimal.name, gender: newAnimal.gender,
        birthDate: newAnimal.birthDate || undefined, weightKg: newAnimal.weightKg,
        color: newAnimal.color, farmId: newAnimal.farmId, notes: newAnimal.notes,
        healthStatus: 'HEALTHY', isActive: true,
      });
      setShowAddAnimalModal(false);
      setNewAnimal({ microchipId: '', animalType: 'CATTLE', breed: '', name: '', gender: 'MALE', birthDate: '', weightKg: 0, color: '', farmId: '', notes: '' });
    } catch (e) {
      alert("Chorva qo'shishda xatolik yuz berdi");
    } finally {
      setLoading(false);
    }
  };

  // ==================== RENDER FUNCTIONS ====================

  const renderStatCard = (icon: React.ReactNode, label: string, value: number | string, color: string, sub?: string) => (
    <div className={`rounded-[16px] p-4 border ${color} flex flex-col gap-1`}>
      <div className="flex items-center justify-between">
        <span className="text-[10px] font-bold uppercase tracking-wider opacity-60">{label}</span>
        {icon}
      </div>
      <span className="text-2xl font-black">{value}</span>
      {sub && <span className="text-[10px] opacity-50">{sub}</span>}
    </div>
  );

  const renderOverview = () => (
    <div className="space-y-4">
      {/* Stats Grid */}
      <div className="grid grid-cols-2 gap-3">
        {renderStatCard(<Building2 size={16} />, 'Fermalar', stats?.totalFarms || 0, 'bg-blue-50 border-blue-100 text-blue-800')}
        {renderStatCard(<Beef size={16} />, 'Jami Chorva', stats?.totalLivestock || 0, 'bg-emerald-50 border-emerald-100 text-emerald-800')}
        {renderStatCard(<Cpu size={16} />, 'Microchiplar', stats?.totalMicrochips || 0, 'bg-purple-50 border-purple-100 text-purple-800')}
        {renderStatCard(<Heart size={16} />, "Sog'lom", stats?.byHealth?.HEALTHY?.count || 0, 'bg-green-50 border-green-100 text-green-800')}
      </div>

      {/* Animal Type Breakdown */}
      <div className="bg-white/80 rounded-[18px] border border-slate-100 p-4">
        <h3 className="text-xs font-bold text-slate-500 uppercase mb-3">Chorva Turlari</h3>
        <div className="space-y-2">
          {(['CATTLE', 'SHEEP', 'GOAT', 'HORSE', 'CAMEL'] as AnimalType[]).map(type => {
            const count = stats?.byType?.[type]?.count || 0;
            const total = stats?.totalLivestock || 1;
            const pct = Math.round((count / total) * 100);
            return (
              <div key={type} className="flex items-center gap-3">
                <span className="text-lg w-8">{ANIMAL_ICONS[type]}</span>
                <div className="flex-1">
                  <div className="flex justify-between items-center mb-1">
                    <span className="text-xs font-bold text-slate-700">{ANIMAL_LABELS[type]}</span>
                    <span className="text-xs font-bold text-slate-500">{count} ta</span>
                  </div>
                  <div className="h-2 bg-slate-100 rounded-full overflow-hidden">
                    <div className="h-full bg-gradient-to-r from-blue-500 to-blue-400 rounded-full transition-all" style={{ width: `${pct}%` }} />
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Health Status */}
      <div className="bg-white/80 rounded-[18px] border border-slate-100 p-4">
        <h3 className="text-xs font-bold text-slate-500 uppercase mb-3">Salomatlik Holati</h3>
        <div className="flex flex-wrap gap-2">
          {(Object.keys(HEALTH_COLORS) as HealthStatus[]).map(hs => {
            const count = stats?.byHealth?.[hs]?.count || 0;
            const { bg, text, label } = HEALTH_COLORS[hs];
            return (
              <div key={hs} className={`${bg} ${text} px-3 py-2 rounded-[12px] flex items-center gap-2`}>
                <span className="text-lg font-black">{count}</span>
                <span className="text-[10px] font-bold">{label}</span>
              </div>
            );
          })}
        </div>
      </div>

      {/* Gender Stats */}
      <div className="bg-white/80 rounded-[18px] border border-slate-100 p-4">
        <h3 className="text-xs font-bold text-slate-500 uppercase mb-3">Jinsi</h3>
        <div className="flex gap-3">
          <div className="flex-1 bg-blue-50 rounded-[12px] p-3 text-center border border-blue-100">
            <span className="text-2xl font-black text-blue-700">{stats?.byGender?.MALE || 0}</span>
            <span className="block text-[10px] font-bold text-blue-500 mt-1">Erkak</span>
          </div>
          <div className="flex-1 bg-pink-50 rounded-[12px] p-3 text-center border border-pink-100">
            <span className="text-2xl font-black text-pink-700">{stats?.byGender?.FEMALE || 0}</span>
            <span className="block text-[10px] font-bold text-pink-500 mt-1">Urg'ochi</span>
          </div>
        </div>
      </div>

      {/* Quick Farm Summary */}
      {stats?.farmsSummary && stats.farmsSummary.length > 0 && (
        <div className="bg-white/80 rounded-[18px] border border-slate-100 p-4">
          <h3 className="text-xs font-bold text-slate-500 uppercase mb-3">Fermalar Xulosasi</h3>
          <div className="space-y-2">
            {stats.farmsSummary.map(fs => (
              <div key={fs.id} className="flex items-center justify-between bg-slate-50 rounded-[12px] p-3 border border-slate-100 cursor-pointer hover:bg-slate-100 transition-colors"
                onClick={() => { const farm = farms.find(f => f.id === fs.id); if (farm) { setSelectedFarm(farm); setView('livestock'); } }}>
                <div>
                  <span className="text-xs font-bold text-slate-800 block">{fs.name}</span>
                  <span className="text-[10px] text-slate-400">{fs.owner}</span>
                </div>
                <div className="flex items-center gap-2">
                  <span className="text-xs font-bold text-slate-600">{fs.total} bosh</span>
                  {fs.sick > 0 && <span className="text-[9px] font-bold bg-red-100 text-red-600 px-2 py-0.5 rounded-full">{fs.sick} kasal</span>}
                  <ChevronRight size={14} className="text-slate-300" />
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );

  const renderFarms = () => (
    <div className="space-y-3">
      {farms.length === 0 ? (
        <div className="text-center py-10 opacity-50">
          <Building2 size={32} className="mx-auto mb-2 text-slate-400" />
          <p className="text-xs font-bold text-slate-500">Hozircha ferma yo'q</p>
        </div>
      ) : (
        farms.map(farm => (
          <div key={farm.id} className="bg-white/80 rounded-[18px] border border-slate-100 p-4 hover:shadow-md transition-all cursor-pointer"
            onClick={() => { setSelectedFarm(farm); setView('livestock'); }}>
            <div className="flex items-start justify-between">
              <div className="flex-1">
                <div className="flex items-center gap-2 mb-1">
                  <h3 className="text-sm font-bold text-slate-800">{farm.name}</h3>
                  <span className="text-[9px] font-bold bg-blue-100 text-blue-600 px-2 py-0.5 rounded-full">{FARM_TYPE_LABELS[farm.farmType]}</span>
                </div>
                <div className="flex items-center gap-3 text-[10px] text-slate-400">
                  <span className="flex items-center gap-1"><User size={10} /> {farm.ownerName}</span>
                  <span className="flex items-center gap-1"><Phone size={10} /> {farm.ownerPhone}</span>
                </div>
                <div className="flex items-center gap-3 mt-1 text-[10px] text-slate-400">
                  <span className="flex items-center gap-1"><MapPin size={10} /> {farm.address}</span>
                </div>
              </div>
              <div className="text-right">
                <span className="text-xl font-black text-slate-700">{farm.livestockCount || 0}</span>
                <span className="block text-[9px] font-bold text-slate-400">bosh</span>
              </div>
            </div>

            {/* Livestock Stats per type */}
            {farm.livestockStats && Object.keys(farm.livestockStats).length > 0 && (
              <div className="flex flex-wrap gap-2 mt-3 pt-3 border-t border-slate-100">
                {Object.entries(farm.livestockStats).map(([type, data]) => (
                  <div key={type} className="flex items-center gap-1 bg-slate-50 px-2 py-1 rounded-lg">
                    <span className="text-sm">{ANIMAL_ICONS[type as AnimalType]}</span>
                    <span className="text-[10px] font-bold text-slate-600">{data.count}</span>
                    {data.sick > 0 && <span className="text-[9px] font-bold text-red-500">({data.sick})</span>}
                  </div>
                ))}
              </div>
            )}

            <div className="flex justify-end mt-2">
              <button onClick={(e) => { e.stopPropagation(); if (confirm("Fermani o'chirmoqchimisiz?")) onDeleteFarm(farm.id); }}
                className="text-[9px] text-red-400 hover:text-red-600 font-bold flex items-center gap-1">
                <Trash2 size={10} /> O'chirish
              </button>
            </div>
          </div>
        ))
      )}
    </div>
  );

  const renderLivestockList = () => (
    <div className="space-y-3">
      {/* Filters */}
      <div className="flex gap-2 overflow-x-auto pb-1">
        {[{ id: 'ALL', label: 'Barchasi' }, ...(['CATTLE', 'SHEEP', 'GOAT', 'HORSE', 'CAMEL'] as AnimalType[]).map(t => ({ id: t, label: ANIMAL_LABELS[t] }))].map(f => (
          <button key={f.id} onClick={() => setFilterType(f.id as any)}
            className={`px-3 py-1.5 rounded-lg text-[10px] font-bold whitespace-nowrap transition-all border ${filterType === f.id ? 'bg-slate-800 text-white border-slate-800' : 'bg-white/50 text-slate-600 border-white hover:bg-white'}`}>
            {f.id !== 'ALL' && <span className="mr-1">{ANIMAL_ICONS[f.id as AnimalType]}</span>}{f.label}
          </button>
        ))}
      </div>

      {/* Health Filter */}
      <div className="flex gap-1.5 overflow-x-auto pb-1">
        <button onClick={() => setFilterHealth('ALL')} className={`px-2 py-1 rounded-md text-[9px] font-bold ${filterHealth === 'ALL' ? 'bg-slate-700 text-white' : 'bg-slate-100 text-slate-500'}`}>Barchasi</button>
        {(Object.keys(HEALTH_COLORS) as HealthStatus[]).map(hs => (
          <button key={hs} onClick={() => setFilterHealth(hs)}
            className={`px-2 py-1 rounded-md text-[9px] font-bold ${filterHealth === hs ? HEALTH_COLORS[hs].bg + ' ' + HEALTH_COLORS[hs].text : 'bg-slate-100 text-slate-500'}`}>
            {HEALTH_COLORS[hs].label}
          </button>
        ))}
      </div>

      {/* Search */}
      <div className="relative">
        <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
        <input type="text" value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)}
          placeholder="Microchip ID, nom yoki zot bo'yicha qidirish..."
          className="w-full bg-white/80 border border-slate-200 rounded-[12px] pl-9 pr-4 py-2.5 text-xs font-medium text-slate-800 outline-none focus:ring-2 focus:ring-blue-500/20" />
      </div>

      {selectedFarm && (
        <div className="flex items-center gap-2 bg-blue-50 rounded-[12px] px-3 py-2 border border-blue-100">
          <Building2 size={14} className="text-blue-600" />
          <span className="text-xs font-bold text-blue-700">{selectedFarm.name}</span>
          <button onClick={() => setSelectedFarm(null)} className="ml-auto text-blue-400 hover:text-blue-600"><X size={14} /></button>
        </div>
      )}

      <div className="text-[10px] font-bold text-slate-400">{filteredLivestock.length} ta chorva topildi</div>

      {/* Livestock Cards */}
      {filteredLivestock.length === 0 ? (
        <div className="text-center py-10 opacity-50">
          <Beef size={32} className="mx-auto mb-2 text-slate-400" />
          <p className="text-xs font-bold text-slate-500">Chorva topilmadi</p>
        </div>
      ) : (
        <div className="space-y-2">
          {filteredLivestock.map(animal => {
            const hc = HEALTH_COLORS[animal.healthStatus];
            return (
              <div key={animal.id} className="bg-white/80 rounded-[16px] border border-slate-100 p-3 hover:shadow-sm transition-all cursor-pointer"
                onClick={() => { setSelectedAnimal(animal); setView('passport'); }}>
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-[12px] bg-slate-100 flex items-center justify-center text-xl">
                    {ANIMAL_ICONS[animal.animalType]}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2">
                      <span className="text-xs font-bold text-slate-800 truncate">{animal.name || animal.breed}</span>
                      <span className={`text-[8px] font-bold px-1.5 py-0.5 rounded-full ${hc.bg} ${hc.text}`}>{hc.label}</span>
                    </div>
                    <div className="flex items-center gap-2 mt-0.5">
                      <span className="text-[9px] text-slate-400 flex items-center gap-1"><Cpu size={9} /> {animal.microchipId}</span>
                      <span className="text-[9px] text-slate-400">{animal.breed}</span>
                      <span className="text-[9px] text-slate-400">{animal.gender === 'MALE' ? 'Erkak' : "Urg'ochi"}</span>
                    </div>
                    {animal.farmName && <span className="text-[9px] text-blue-400 flex items-center gap-1 mt-0.5"><Building2 size={9} /> {animal.farmName}</span>}
                  </div>
                  <div className="text-right flex-shrink-0">
                    <span className="text-sm font-bold text-slate-700">{animal.weightKg} kg</span>
                    <ChevronRight size={14} className="text-slate-300 ml-1 inline" />
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );

  const renderScanner = () => (
    <div className="space-y-4">
      <div className="bg-gradient-to-br from-purple-500 to-indigo-600 rounded-[20px] p-6 text-white">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-12 h-12 rounded-full bg-white/20 flex items-center justify-center">
            <ScanLine size={24} />
          </div>
          <div>
            <h3 className="text-base font-bold">Microchip Scanner</h3>
            <p className="text-xs opacity-70">Chorva ID sini kiriting yoki skanerlang</p>
          </div>
        </div>
        <div className="flex gap-2">
          <input type="text" value={scannerInput} onChange={(e) => setScannerInput(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleScan()}
            placeholder="Microchip ID kiriting..."
            className="flex-1 bg-white/20 border border-white/30 rounded-[12px] px-4 py-3 text-sm font-bold text-white placeholder-white/50 outline-none focus:bg-white/30" />
          <button onClick={handleScan} disabled={scanLoading}
            className="px-6 py-3 bg-white text-purple-600 rounded-[12px] font-bold text-sm hover:bg-white/90 disabled:opacity-50 flex items-center gap-2">
            {scanLoading ? <RefreshCw size={16} className="animate-spin" /> : <Search size={16} />}
            Qidirish
          </button>
        </div>
      </div>

      {scanError && (
        <div className="bg-red-50 border border-red-200 rounded-[14px] p-4 flex items-center gap-3">
          <AlertTriangle size={18} className="text-red-500" />
          <span className="text-xs font-bold text-red-700">{scanError}</span>
        </div>
      )}

      {scanResult && (
        <div className="bg-white rounded-[20px] border border-slate-200 shadow-lg overflow-hidden">
          <div className="bg-gradient-to-r from-emerald-500 to-green-500 p-4 text-white">
            <div className="flex items-center gap-3">
              <span className="text-3xl">{ANIMAL_ICONS[scanResult.animalType]}</span>
              <div>
                <h3 className="text-base font-bold">{scanResult.name || scanResult.breed}</h3>
                <p className="text-xs opacity-80">Microchip: {scanResult.microchipId}</p>
              </div>
              <div className="ml-auto">
                <span className={`text-[10px] font-bold px-3 py-1 rounded-full bg-white/20`}>
                  {HEALTH_COLORS[scanResult.healthStatus].label}
                </span>
              </div>
            </div>
          </div>
          <div className="p-4 space-y-3">
            <div className="grid grid-cols-2 gap-3">
              {[
                { icon: <Beef size={14} />, label: 'Turi', value: ANIMAL_LABELS[scanResult.animalType] },
                { icon: <FileText size={14} />, label: 'Zoti', value: scanResult.breed },
                { icon: <User size={14} />, label: 'Jinsi', value: scanResult.gender === 'MALE' ? 'Erkak' : "Urg'ochi" },
                { icon: <Weight size={14} />, label: 'Vazni', value: `${scanResult.weightKg} kg` },
                { icon: <Palette size={14} />, label: 'Rangi', value: scanResult.color || '-' },
                { icon: <Calendar size={14} />, label: "Tug'ilgan", value: scanResult.birthDate || '-' },
                { icon: <Shield size={14} />, label: 'Emlash', value: scanResult.lastVaccinationDate || '-' },
                { icon: <Activity size={14} />, label: 'Tekshiruv', value: scanResult.lastVetCheck || '-' },
              ].map((item, i) => (
                <div key={i} className="flex items-center gap-2 bg-slate-50 rounded-[10px] p-2.5 border border-slate-100">
                  <div className="text-slate-400">{item.icon}</div>
                  <div>
                    <span className="text-[9px] text-slate-400 block">{item.label}</span>
                    <span className="text-xs font-bold text-slate-700">{item.value}</span>
                  </div>
                </div>
              ))}
            </div>
            {scanResult.farmName && (
              <div className="flex items-center gap-2 bg-blue-50 rounded-[12px] p-3 border border-blue-100">
                <Building2 size={14} className="text-blue-600" />
                <span className="text-xs font-bold text-blue-700">Ferma: {scanResult.farmName}</span>
              </div>
            )}
            {scanResult.notes && (
              <div className="bg-amber-50 rounded-[12px] p-3 border border-amber-100">
                <span className="text-[10px] font-bold text-amber-600 block mb-1">Izoh</span>
                <span className="text-xs text-amber-800">{scanResult.notes}</span>
              </div>
            )}
            <button onClick={() => { setSelectedAnimal(scanResult); setView('passport'); }}
              className="w-full py-2.5 bg-slate-800 text-white rounded-[12px] font-bold text-xs flex items-center justify-center gap-2 hover:bg-slate-700">
              <FileText size={14} /> To'liq Pasportni Ko'rish
            </button>
          </div>
        </div>
      )}
    </div>
  );

  const renderPassport = () => {
    if (!selectedAnimal) return null;
    const a = selectedAnimal;
    const hc = HEALTH_COLORS[a.healthStatus];
    return (
      <div className="space-y-4">
        <button onClick={() => { setSelectedAnimal(null); setView('livestock'); }}
          className="flex items-center gap-2 text-xs font-bold text-slate-500 hover:text-blue-600">
          <ArrowLeft size={14} /> Orqaga
        </button>

        {/* Header Card */}
        <div className={`rounded-[20px] p-5 border-2 ${a.healthStatus === 'SICK' ? 'border-red-300 bg-red-50' : a.healthStatus === 'QUARANTINE' ? 'border-orange-300 bg-orange-50' : 'border-emerald-300 bg-emerald-50'}`}>
          <div className="flex items-center gap-4">
            <div className="w-16 h-16 rounded-[16px] bg-white shadow-md flex items-center justify-center text-3xl">
              {ANIMAL_ICONS[a.animalType]}
            </div>
            <div className="flex-1">
              <h2 className="text-lg font-black text-slate-800">{a.name || a.breed}</h2>
              <div className="flex items-center gap-2 mt-1">
                <span className="text-[10px] font-bold bg-white px-2 py-0.5 rounded-full text-slate-600 flex items-center gap-1"><Cpu size={10} /> {a.microchipId}</span>
                <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${hc.bg} ${hc.text}`}>{hc.label}</span>
              </div>
            </div>
          </div>
        </div>

        {/* Details Grid */}
        <div className="bg-white/80 rounded-[18px] border border-slate-100 p-4">
          <h3 className="text-xs font-bold text-slate-500 uppercase mb-3">Asosiy Ma'lumotlar</h3>
          <div className="grid grid-cols-2 gap-2">
            {[
              { label: 'Turi', value: ANIMAL_LABELS[a.animalType], icon: ANIMAL_ICONS[a.animalType] },
              { label: 'Zoti', value: a.breed },
              { label: 'Jinsi', value: a.gender === 'MALE' ? 'Erkak' : "Urg'ochi" },
              { label: 'Vazni', value: `${a.weightKg} kg` },
              { label: 'Rangi', value: a.color || 'Noma\'lum' },
              { label: "Tug'ilgan sana", value: a.birthDate || 'Noma\'lum' },
              { label: "So'nggi emlash", value: a.lastVaccinationDate || 'Noma\'lum' },
              { label: "So'nggi tekshiruv", value: a.lastVetCheck || 'Noma\'lum' },
            ].map((item, i) => (
              <div key={i} className="bg-slate-50 rounded-[10px] p-2.5 border border-slate-100">
                <span className="text-[9px] text-slate-400 block">{item.label}</span>
                <span className="text-xs font-bold text-slate-700">{item.value}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Passport Data */}
        {a.passport && (
          <div className="bg-white/80 rounded-[18px] border border-slate-100 p-4">
            <h3 className="text-xs font-bold text-slate-500 uppercase mb-3 flex items-center gap-2"><FileText size={14} /> Pasport Ma'lumotlari</h3>
            <div className="space-y-2">
              <div className="bg-slate-50 rounded-[10px] p-2.5 border border-slate-100">
                <span className="text-[9px] text-slate-400 block">Pasport raqami</span>
                <span className="text-xs font-bold text-slate-700">{a.passport.passportNumber}</span>
              </div>
              <div className="grid grid-cols-2 gap-2">
                <div className="bg-slate-50 rounded-[10px] p-2.5 border border-slate-100">
                  <span className="text-[9px] text-slate-400 block">Berilgan sana</span>
                  <span className="text-xs font-bold text-slate-700">{a.passport.issueDate}</span>
                </div>
                <div className="bg-slate-50 rounded-[10px] p-2.5 border border-slate-100">
                  <span className="text-[9px] text-slate-400 block">Bergan tashkilot</span>
                  <span className="text-xs font-bold text-slate-700">{a.passport.issuingAuthority}</span>
                </div>
              </div>
              {a.passport.motherMicrochipId && (
                <div className="bg-pink-50 rounded-[10px] p-2.5 border border-pink-100">
                  <span className="text-[9px] text-pink-400 block">Onasi (Microchip)</span>
                  <span className="text-xs font-bold text-pink-700">{a.passport.motherMicrochipId}</span>
                </div>
              )}
              {a.passport.fatherMicrochipId && (
                <div className="bg-blue-50 rounded-[10px] p-2.5 border border-blue-100">
                  <span className="text-[9px] text-blue-400 block">Otasi (Microchip)</span>
                  <span className="text-xs font-bold text-blue-700">{a.passport.fatherMicrochipId}</span>
                </div>
              )}

              {/* Vaccination History */}
              {a.passport.vaccinationHistory && a.passport.vaccinationHistory.length > 0 && (
                <div>
                  <span className="text-[10px] font-bold text-slate-500 block mb-1">Emlash Tarixi</span>
                  {a.passport.vaccinationHistory.map((v, i) => (
                    <div key={i} className="flex items-center gap-2 bg-green-50 rounded-lg p-2 mb-1 border border-green-100">
                      <Shield size={12} className="text-green-500" />
                      <span className="text-[10px] font-bold text-green-700">{v.vaccine}</span>
                      <span className="text-[9px] text-green-500 ml-auto">{v.date}</span>
                    </div>
                  ))}
                </div>
              )}

              {/* Weight History */}
              {a.passport.weightHistory && a.passport.weightHistory.length > 0 && (
                <div>
                  <span className="text-[10px] font-bold text-slate-500 block mb-1">Vazn Tarixi</span>
                  <div className="flex gap-2 overflow-x-auto pb-1">
                    {a.passport.weightHistory.map((w, i) => (
                      <div key={i} className="bg-slate-50 rounded-lg p-2 border border-slate-100 text-center min-w-[60px]">
                        <span className="text-xs font-bold text-slate-700 block">{w.weight} kg</span>
                        <span className="text-[8px] text-slate-400">{w.date}</span>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        )}

        {a.notes && (
          <div className="bg-amber-50 rounded-[18px] border border-amber-100 p-4">
            <h3 className="text-xs font-bold text-amber-600 mb-2">Izohlar</h3>
            <p className="text-xs text-amber-800">{a.notes}</p>
          </div>
        )}

        {/* Actions */}
        <div className="flex gap-2">
          <button onClick={() => { if (confirm("Chorvani o'chirmoqchimisiz?")) { onDeleteLivestock(a.id); setSelectedAnimal(null); setView('livestock'); } }}
            className="flex-1 py-2.5 bg-red-50 text-red-600 rounded-[12px] font-bold text-xs flex items-center justify-center gap-2 border border-red-200 hover:bg-red-100">
            <Trash2 size={14} /> O'chirish
          </button>
        </div>
      </div>
    );
  };

  // ==================== MODALS ====================

  const renderAddFarmModal = () => (
    <div className="absolute inset-0 z-[180] bg-slate-900/40 backdrop-blur-md flex items-center justify-center p-6 animate-in fade-in duration-200">
      <div className="bg-white w-full max-w-md rounded-[24px] shadow-2xl flex flex-col overflow-hidden max-h-[85vh]">
        <div className="p-5 border-b border-slate-100 flex justify-between items-center bg-slate-50">
          <h3 className="text-lg font-bold text-slate-800 flex items-center gap-2"><Building2 className="text-green-600" /> Yangi Ferma</h3>
          <button onClick={() => setShowAddFarmModal(false)} className="w-8 h-8 rounded-full hover:bg-slate-200 flex items-center justify-center text-slate-400"><X size={18} /></button>
        </div>
        <div className="flex-1 overflow-y-auto p-6 space-y-4">
          <div>
            <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Ferma Nomi *</label>
            <input type="text" value={newFarm.name} onChange={(e) => setNewFarm({ ...newFarm, name: e.target.value })} placeholder="Masalan: Bahor Fermasi"
              className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none focus:ring-2 focus:ring-blue-500/20" />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Egasi Ismi *</label>
              <input type="text" value={newFarm.ownerName} onChange={(e) => setNewFarm({ ...newFarm, ownerName: e.target.value })}
                className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none" />
            </div>
            <div>
              <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Telefon</label>
              <input type="text" value={newFarm.ownerPhone} onChange={(e) => setNewFarm({ ...newFarm, ownerPhone: e.target.value })} placeholder="+998..."
                className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none" />
            </div>
          </div>
          <div>
            <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Ferma Turi</label>
            <select value={newFarm.farmType} onChange={(e) => setNewFarm({ ...newFarm, farmType: e.target.value as FarmType })}
              className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none">
              {Object.entries(FARM_TYPE_LABELS).map(([k, v]) => <option key={k} value={k}>{v}</option>)}
            </select>
          </div>
          <div>
            <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Manzil</label>
            <input type="text" value={newFarm.address} onChange={(e) => setNewFarm({ ...newFarm, address: e.target.value })}
              className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none" />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">MFY</label>
              <input type="text" value={newFarm.mfy} onChange={(e) => setNewFarm({ ...newFarm, mfy: e.target.value })}
                className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none" />
            </div>
            <div>
              <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Maydon (ga)</label>
              <input type="number" value={newFarm.areaHectares} onChange={(e) => setNewFarm({ ...newFarm, areaHectares: parseFloat(e.target.value) || 0 })}
                className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none" />
            </div>
          </div>
        </div>
        <div className="p-5 border-t border-slate-100 flex justify-end gap-3">
          <button onClick={() => setShowAddFarmModal(false)} className="px-5 py-2.5 rounded-[12px] font-bold text-xs text-slate-500 hover:bg-slate-100">Bekor</button>
          <button onClick={handleAddFarm} disabled={loading || !newFarm.name || !newFarm.ownerName}
            className="px-6 py-2.5 rounded-[12px] bg-green-600 text-white font-bold text-xs hover:bg-green-700 shadow-lg disabled:opacity-50 flex items-center gap-2">
            {loading ? <RefreshCw size={14} className="animate-spin" /> : <Check size={14} />} Saqlash
          </button>
        </div>
      </div>
    </div>
  );

  const renderAddAnimalModal = () => (
    <div className="absolute inset-0 z-[180] bg-slate-900/40 backdrop-blur-md flex items-center justify-center p-6 animate-in fade-in duration-200">
      <div className="bg-white w-full max-w-md rounded-[24px] shadow-2xl flex flex-col overflow-hidden max-h-[85vh]">
        <div className="p-5 border-b border-slate-100 flex justify-between items-center bg-slate-50">
          <h3 className="text-lg font-bold text-slate-800 flex items-center gap-2"><Beef className="text-emerald-600" /> Yangi Chorva</h3>
          <button onClick={() => setShowAddAnimalModal(false)} className="w-8 h-8 rounded-full hover:bg-slate-200 flex items-center justify-center text-slate-400"><X size={18} /></button>
        </div>
        <div className="flex-1 overflow-y-auto p-6 space-y-4">
          <div>
            <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Ferma *</label>
            <select value={newAnimal.farmId} onChange={(e) => setNewAnimal({ ...newAnimal, farmId: e.target.value })}
              className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none">
              <option value="">Fermani tanlang</option>
              {farms.map(f => <option key={f.id} value={f.id}>{f.name} - {f.ownerName}</option>)}
            </select>
          </div>
          <div>
            <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Microchip ID *</label>
            <input type="text" value={newAnimal.microchipId} onChange={(e) => setNewAnimal({ ...newAnimal, microchipId: e.target.value })} placeholder="MC-001234"
              className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none" />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Turi *</label>
              <select value={newAnimal.animalType} onChange={(e) => setNewAnimal({ ...newAnimal, animalType: e.target.value as AnimalType })}
                className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none">
                {Object.entries(ANIMAL_LABELS).map(([k, v]) => <option key={k} value={k}>{v}</option>)}
              </select>
            </div>
            <div>
              <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Jinsi</label>
              <select value={newAnimal.gender} onChange={(e) => setNewAnimal({ ...newAnimal, gender: e.target.value as 'MALE' | 'FEMALE' })}
                className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none">
                <option value="MALE">Erkak</option>
                <option value="FEMALE">Urg'ochi</option>
              </select>
            </div>
          </div>
          <div>
            <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Zoti *</label>
            <input type="text" value={newAnimal.breed} onChange={(e) => setNewAnimal({ ...newAnimal, breed: e.target.value })} placeholder="Masalan: Golshteyn"
              className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none" />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Nomi</label>
              <input type="text" value={newAnimal.name} onChange={(e) => setNewAnimal({ ...newAnimal, name: e.target.value })}
                className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none" />
            </div>
            <div>
              <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Rangi</label>
              <input type="text" value={newAnimal.color} onChange={(e) => setNewAnimal({ ...newAnimal, color: e.target.value })}
                className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none" />
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Vazni (kg)</label>
              <input type="number" value={newAnimal.weightKg} onChange={(e) => setNewAnimal({ ...newAnimal, weightKg: parseFloat(e.target.value) || 0 })}
                className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none" />
            </div>
            <div>
              <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Tug'ilgan sana</label>
              <input type="date" value={newAnimal.birthDate} onChange={(e) => setNewAnimal({ ...newAnimal, birthDate: e.target.value })}
                className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none" />
            </div>
          </div>
          <div>
            <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1.5">Izoh</label>
            <textarea value={newAnimal.notes} onChange={(e) => setNewAnimal({ ...newAnimal, notes: e.target.value })} rows={2}
              className="w-full bg-slate-50 border border-slate-200 rounded-[12px] px-4 py-2.5 text-sm font-bold text-slate-800 outline-none resize-none" />
          </div>
        </div>
        <div className="p-5 border-t border-slate-100 flex justify-end gap-3">
          <button onClick={() => setShowAddAnimalModal(false)} className="px-5 py-2.5 rounded-[12px] font-bold text-xs text-slate-500 hover:bg-slate-100">Bekor</button>
          <button onClick={handleAddAnimal} disabled={loading || !newAnimal.microchipId || !newAnimal.breed || !newAnimal.farmId}
            className="px-6 py-2.5 rounded-[12px] bg-emerald-600 text-white font-bold text-xs hover:bg-emerald-700 shadow-lg disabled:opacity-50 flex items-center gap-2">
            {loading ? <RefreshCw size={14} className="animate-spin" /> : <Check size={14} />} Saqlash
          </button>
        </div>
      </div>
    </div>
  );

  // ==================== MAIN RENDER ====================

  return (
    <div className="h-full flex flex-col bg-white/40 relative">
      {/* Header */}
      <div className="p-5 border-b border-white/50 bg-white/30 backdrop-blur-md sticky top-0 z-10">
        <div className="flex items-center justify-between mb-3">
          <h2 className="text-base font-bold text-slate-700 flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-[10px] bg-emerald-500 text-white flex items-center justify-center shadow-lg shadow-emerald-500/20">
              <Beef size={16} />
            </div>
            Chorva Monitoringi
          </h2>
          <div className="flex gap-2">
            <button onClick={() => setShowAddAnimalModal(true)} className="w-8 h-8 rounded-full bg-emerald-600 text-white flex items-center justify-center transition-all shadow-md hover:scale-105 active:scale-95" title="Yangi Chorva"><Plus size={18} /></button>
            <button onClick={() => setShowAddFarmModal(true)} className="w-8 h-8 rounded-full bg-blue-600 text-white flex items-center justify-center transition-all shadow-md hover:scale-105 active:scale-95" title="Yangi Ferma"><Building2 size={16} /></button>
            <button onClick={onRefresh} className="w-8 h-8 rounded-full bg-slate-100 hover:bg-white border border-white flex items-center justify-center transition-all text-slate-500 hover:text-blue-600 shadow-sm"><RefreshCw size={16} /></button>
          </div>
        </div>

        {/* Navigation Tabs */}
        <div className="flex gap-2 overflow-x-auto pb-1">
          {[
            { id: 'overview' as ViewMode, label: 'Umumiy', icon: <TrendingUp size={12} /> },
            { id: 'farms' as ViewMode, label: 'Fermalar', icon: <Building2 size={12} /> },
            { id: 'livestock' as ViewMode, label: 'Chorva', icon: <Beef size={12} /> },
            { id: 'scanner' as ViewMode, label: 'Scanner', icon: <ScanLine size={12} /> },
          ].map(tab => (
            <button key={tab.id} onClick={() => { setView(tab.id); if (tab.id !== 'livestock') setSelectedFarm(null); }}
              className={`px-3 py-1.5 rounded-lg text-[10px] font-bold whitespace-nowrap transition-all border flex items-center gap-1.5 ${view === tab.id || (view === 'passport' && tab.id === 'livestock') ? 'bg-slate-800 text-white border-slate-800 shadow-md' : 'bg-white/50 text-slate-600 border-white hover:bg-white'}`}>
              {tab.icon} {tab.label}
            </button>
          ))}
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 overflow-y-auto p-4 scroll-smooth custom-scrollbar">
        {view === 'overview' && renderOverview()}
        {view === 'farms' && renderFarms()}
        {view === 'livestock' && renderLivestockList()}
        {view === 'scanner' && renderScanner()}
        {view === 'passport' && renderPassport()}
      </div>

      {/* Modals */}
      {showAddFarmModal && renderAddFarmModal()}
      {showAddAnimalModal && renderAddAnimalModal()}
    </div>
  );
};

export default LivestockMonitor;
